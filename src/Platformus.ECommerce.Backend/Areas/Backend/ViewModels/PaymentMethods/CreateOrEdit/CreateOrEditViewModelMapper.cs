﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.Core.Backend.ViewModels;
using Platformus.ECommerce.Data.Entities;

namespace Platformus.ECommerce.Backend.ViewModels.PaymentMethods
{
  public class CreateOrEditViewModelMapper : ViewModelMapperBase
  {
    public PaymentMethod Map(PaymentMethod paymentMethod, CreateOrEditViewModel createOrEdit)
    {
      paymentMethod.Code = createOrEdit.Code;
      paymentMethod.Position = createOrEdit.Position;
      return paymentMethod;
    }
  }
}