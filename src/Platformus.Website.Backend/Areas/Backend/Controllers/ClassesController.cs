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
using Platformus.Website.Backend.ViewModels.Classes;
using Platformus.Website.Data.Entities;
using Platformus.Website.Events;
using Platformus.Website.Filters;

namespace Platformus.Website.Backend.Controllers
{
  [Authorize(Policy = Policies.HasManageClassesPermission)]
  public class ClassesController : Core.Backend.Controllers.ControllerBase
  {
    private IStringLocalizer localizer;

    private IRepository<int, Class, ClassFilter> Repository
    {
      get => this.Storage.GetRepository<int, Class, ClassFilter>();
    }

    public ClassesController(IStorage storage, IStringLocalizer<SharedResource> localizer)
      : base(storage)
    {
      this.localizer = localizer;
    }

    public async Task<IActionResult> IndexAsync([FromQuery]ClassFilter filter = null, string sorting = "+name", int offset = 0, int limit = 10)
    {
      return this.View(await IndexViewModelFactory.CreateAsync(
        this.HttpContext, sorting, offset, limit, await this.Repository.CountAsync(filter),
        await this.Repository.GetAllAsync(filter, sorting, offset, limit, new Inclusion<Class>(c => c.Parent))
      ));
    }

    [HttpGet]
    [ImportModelStateFromTempData]
    public async Task<IActionResult> CreateOrEditAsync(int? id)
    {
      return this.View(await CreateOrEditViewModelFactory.CreateAsync(
        this.HttpContext, id == null ? null : await this.Repository.GetByIdAsync((int)id)
      ));
    }

    [HttpPost]
    [ExportModelStateToTempData]
    public async Task<IActionResult> CreateOrEditAsync(CreateOrEditViewModel createOrEdit)
    {
      if (!await this.IsCodeUniqueAsync(createOrEdit))
        this.ModelState.AddModelError("code", this.localizer["Value is already in use"]);

      if (this.ModelState.IsValid)
      {
        Class @class = CreateOrEditViewModelMapper.Map(
          createOrEdit.Id == null ? new Class() : await this.Repository.GetByIdAsync((int)createOrEdit.Id),
          createOrEdit
        );

        if (createOrEdit.Id == null)
          this.Repository.Create(@class);

        else this.Repository.Edit(@class);

        await this.Storage.SaveAsync();

        if (createOrEdit.Id == null)
          Event<IClassCreatedEventHandler, HttpContext, Class>.Broadcast(this.HttpContext, @class);

        else Event<IClassEditedEventHandler, HttpContext, Class>.Broadcast(this.HttpContext, @class);

        return this.Redirect(this.Request.CombineUrl("/backend/classes"));
      }

      return this.CreateRedirectToSelfResult();
    }

    public async Task<IActionResult> DeleteAsync(int id)
    {
      Class @class = await this.Repository.GetByIdAsync(id);

      this.Repository.Delete(@class.Id);
      await this.Storage.SaveAsync();
      Event<IClassDeletedEventHandler, HttpContext, Class>.Broadcast(this.HttpContext, @class);
      return this.Redirect(this.Request.CombineUrl("/backend/classes"));
    }

    private async Task<bool> IsCodeUniqueAsync(CreateOrEditViewModel createOrEdit)
    {
      Class @class = (await this.Repository.GetAllAsync(new ClassFilter(code: createOrEdit.Code))).FirstOrDefault();

      return @class == null || @class.Id == createOrEdit.Id;
    }
  }
}