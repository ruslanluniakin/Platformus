﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Threading.Tasks;
using ExtCore.Events;
using Magicalizer.Data.Repositories.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Platformus.Core.Backend;
using Platformus.Website.Backend.ViewModels.Forms;
using Platformus.Website.Data.Entities;
using Platformus.Website.Events;
using Platformus.Website.Filters;

namespace Platformus.Website.Backend.Controllers
{
  [Authorize(Policy = Policies.HasManageFormsPermission)]
  public class FormsController : Core.Backend.Controllers.ControllerBase
  {
    private IStringLocalizer localizer;

    private IRepository<int, Form, FormFilter> Repository
    {
      get => this.Storage.GetRepository<int, Form, FormFilter>();
    }

    public FormsController(IStorage storage, IStringLocalizer<SharedResource> localizer)
      : base(storage)
    {
      this.localizer = localizer;
    }

    public async Task<IActionResult> IndexAsync()
    {
      return this.View(IndexViewModelFactory.Create(
        await this.Repository.GetAllAsync(
          inclusions: new Inclusion<Form>[] {
            new Inclusion<Form>(m => m.Name.Localizations),
            new Inclusion<Form>("Fields.FieldType"),
            new Inclusion<Form>("Fields.Name.Localizations"),
            new Inclusion<Form>("Fields.FieldOptions.Value.Localizations")
          }
        )
      ));
    }

    [HttpGet]
    [ImportModelStateFromTempData]
    public async Task<IActionResult> CreateOrEditAsync(int? id)
    {
      return this.View(CreateOrEditViewModelFactory.Create(
        this.HttpContext, id == null ? null : await this.Repository.GetByIdAsync(
          (int)id,
          new Inclusion<Form>(f => f.Name.Localizations),
          new Inclusion<Form>(f => f.SubmitButtonTitle.Localizations)
        )
      ));
    }

    [HttpPost]
    [ExportModelStateToTempData]
    public async Task<IActionResult> CreateOrEditAsync(CreateOrEditViewModel createOrEdit)
    {
      if (createOrEdit.Id == null && !await this.IsCodeUniqueAsync(createOrEdit.Code))
        this.ModelState.AddModelError("code", this.localizer["Value is already in use"]);

      if (this.ModelState.IsValid)
      {
        Form form = CreateOrEditViewModelMapper.Map(
          createOrEdit.Id == null ?
            new Form() :
            await this.Repository.GetByIdAsync(
              (int)createOrEdit.Id,
              new Inclusion<Form>(f => f.Name.Localizations),
              new Inclusion<Form>(f => f.SubmitButtonTitle.Localizations)
            ),
          createOrEdit
        );

        if (createOrEdit.Id == null)
          this.Repository.Create(form);

        else this.Repository.Edit(form);

        await this.MergeEntityLocalizationsAsync(form);
        await this.Storage.SaveAsync();

        if (createOrEdit.Id == null)
          Event<IFormCreatedEventHandler, HttpContext, Form>.Broadcast(this.HttpContext, form);

        else Event<IFormEditedEventHandler, HttpContext, Form>.Broadcast(this.HttpContext, form);

        return this.RedirectToAction("Index");
      }

      return this.CreateRedirectToSelfResult();
    }

    public async Task<IActionResult> DeleteAsync(int id)
    {
      Form form = await this.Repository.GetByIdAsync(id);

      this.Repository.Delete(form.Id);
      await this.Storage.SaveAsync();
      Event<IFormDeletedEventHandler, HttpContext, Form>.Broadcast(this.HttpContext, form);
      return this.RedirectToAction("Index");
    }

    private async Task<bool> IsCodeUniqueAsync(string code)
    {
      return await this.Repository.CountAsync(new FormFilter(code: code)) == 0;
    }
  }
}