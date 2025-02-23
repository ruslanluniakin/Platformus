﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Linq;
using System.Threading.Tasks;
using ExtCore.Events;
using Magicalizer.Data.Repositories.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Platformus.Core.Backend;
using Platformus.Website.Backend.ViewModels.DataSources;
using Platformus.Website.Data.Entities;
using Platformus.Website.Events;
using Platformus.Website.Filters;

namespace Platformus.Website.Backend.Controllers
{
  [Authorize(Policy = Policies.HasManageEndpointsPermission)]
  public class DataSourcesController : Core.Backend.Controllers.ControllerBase
  {
    private IStringLocalizer localizer;

    private IRepository<int, DataSource, DataSourceFilter> Repository
    {
      get => this.Storage.GetRepository<int, DataSource, DataSourceFilter>();
    }

    public DataSourcesController(IStorage storage, IStringLocalizer<SharedResource> localizer)
      : base(storage)
    {
      this.localizer = localizer;
    }

    public async Task<IActionResult> IndexAsync([FromQuery]DataSourceFilter filter = null, string sorting = "+code", int offset = 0, int limit = 10)
    {
      return this.View(await IndexViewModelFactory.CreateAsync(
        this.HttpContext, filter, sorting, offset, limit, await this.Repository.CountAsync(filter),
        await this.Repository.GetAllAsync(filter, sorting, offset, limit)
      ));
    }

    [HttpGet]
    [ImportModelStateFromTempData]
    public async Task<IActionResult> CreateOrEditAsync(int? id)
    {
      return this.View(CreateOrEditViewModelFactory.Create(
        id == null ? null : await this.Repository.GetByIdAsync((int)id)
      ));
    }

    [HttpPost]
    [ExportModelStateToTempData]
    public async Task<IActionResult> CreateOrEditAsync([FromQuery]DataSourceFilter filter, CreateOrEditViewModel createOrEdit)
    {
      if (!await this.IsCodeUniqueAsync(filter, createOrEdit))
        this.ModelState.AddModelError("code", this.localizer["Value is already in use"]);

      if (this.ModelState.IsValid)
      {
        DataSource dataSource = CreateOrEditViewModelMapper.Map(
          filter,
          createOrEdit.Id == null ? new DataSource() : await this.Repository.GetByIdAsync((int)createOrEdit.Id),
          createOrEdit
        );

        if (createOrEdit.Id == null)
          this.Repository.Create(dataSource);

        else this.Repository.Edit(dataSource);

        await this.Storage.SaveAsync();

        if (createOrEdit.Id == null)
          Event<IDataSourceCreatedEventHandler, HttpContext, DataSource>.Broadcast(this.HttpContext, dataSource);

        else Event<IDataSourceEditedEventHandler, HttpContext, DataSource, DataSource>.Broadcast(this.HttpContext, await this.Repository.GetByIdAsync((int)createOrEdit.Id), dataSource);

        return this.Redirect(this.Request.CombineUrl("/backend/datasources"));
      }

      return this.CreateRedirectToSelfResult();
    }

    public async Task<IActionResult> DeleteAsync(int id)
    {
      DataSource dataSource = await this.Repository.GetByIdAsync(id);

      this.Repository.Delete(dataSource.Id);
      await this.Storage.SaveAsync();
      Event<IDataSourceDeletedEventHandler, HttpContext, DataSource>.Broadcast(this.HttpContext, dataSource);
      return this.Redirect(this.Request.CombineUrl("/backend/datasources"));
    }

    private async Task<bool> IsCodeUniqueAsync(DataSourceFilter filter, CreateOrEditViewModel createOrEdit)
    {
      filter.Code = createOrEdit.Code;

      DataSource dataSource = (await this.Repository.GetAllAsync(filter)).FirstOrDefault();

      return dataSource == null || dataSource.Id == createOrEdit.Id;
    }
  }
}