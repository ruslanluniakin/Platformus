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
using Platformus.ECommerce.Backend.ViewModels.PaymentMethods;
using Platformus.ECommerce.Data.Entities;
using Platformus.ECommerce.Events;
using Platformus.ECommerce.Filters;

namespace Platformus.ECommerce.Backend.Controllers
{
  [Authorize(Policy = Policies.HasManagePaymentMethodsPermission)]
  public class PaymentMethodsController : Core.Backend.Controllers.ControllerBase
  {
    private IStringLocalizer localizer;

    private IRepository<int, PaymentMethod, PaymentMethodFilter> Repository
    {
      get => this.Storage.GetRepository<int, PaymentMethod, PaymentMethodFilter>();
    }

    public PaymentMethodsController(IStorage storage, IStringLocalizer<SharedResource> localizer)
      : base(storage)
    {
      this.localizer = localizer;
    }

    public async Task<IActionResult> IndexAsync([FromQuery]PaymentMethodFilter filter = null, string sorting = "+position", int offset = 0, int limit = 10)
    {
      return this.View(IndexViewModelFactory.Create(
        sorting, offset, limit, await this.Repository.CountAsync(filter),
        await this.Repository.GetAllAsync(filter, sorting, offset, limit, new Inclusion<PaymentMethod>(pm => pm.Name.Localizations))
      ));
    }

    [HttpGet]
    [ImportModelStateFromTempData]
    public async Task<IActionResult> CreateOrEditAsync(int? id)
    {
      return this.View(CreateOrEditViewModelFactory.Create(
        this.HttpContext, id == null ? null : await this.Repository.GetByIdAsync(
          (int)id, new Inclusion<PaymentMethod>(pm => pm.Name.Localizations)
        )
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
        PaymentMethod paymentMethod = CreateOrEditViewModelMapper.Map(
          createOrEdit.Id == null ?
            new PaymentMethod() :
            await this.Repository.GetByIdAsync(
              (int)createOrEdit.Id,
              new Inclusion<PaymentMethod>(pm => pm.Name.Localizations)
            ),
          createOrEdit
        );

        if (createOrEdit.Id == null)
          this.Repository.Create(paymentMethod);

        else this.Repository.Edit(paymentMethod);

        await this.MergeEntityLocalizationsAsync(paymentMethod);
        await this.Storage.SaveAsync();

        if (createOrEdit.Id == null)
          Event<IPaymentMethodCreatedEventHandler, HttpContext, PaymentMethod>.Broadcast(this.HttpContext, paymentMethod);

        else Event<IPaymentMethodEditedEventHandler, HttpContext, PaymentMethod>.Broadcast(this.HttpContext, paymentMethod);

        return this.Redirect(this.Request.CombineUrl("/backend/paymentmethods"));
      }

      return this.CreateRedirectToSelfResult();
    }

    public async Task<ActionResult> DeleteAsync(int id)
    {
      PaymentMethod paymentMethod = await this.Repository.GetByIdAsync(id);

      this.Repository.Delete(paymentMethod.Id);
      await this.Storage.SaveAsync();
      Event<IPaymentMethodCreatedEventHandler, HttpContext, PaymentMethod>.Broadcast(this.HttpContext, paymentMethod);
      return this.Redirect(this.Request.CombineUrl("/backend/paymentmethods"));
    }

    private async Task<bool> IsCodeUniqueAsync(CreateOrEditViewModel createOrEdit)
    {
      PaymentMethod paymentMethod = (await this.Repository.GetAllAsync(new PaymentMethodFilter(code: createOrEdit.Code))).FirstOrDefault();

      return paymentMethod == null || paymentMethod.Id == createOrEdit.Id;
    }
  }
}