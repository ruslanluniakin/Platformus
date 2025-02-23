﻿// Copyright © 2021 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.ECommerce.Data.Entities;

namespace Platformus.ECommerce.Frontend.ViewModels.Shared
{
  public static class DeliveryMethodViewModelFactory
  {
    public static DeliveryMethodViewModel Create(DeliveryMethod deliveryMethod)
    {
      return new DeliveryMethodViewModel()
      {
        Id = deliveryMethod.Id,
        Name = deliveryMethod.Name.GetLocalizationValue()
      };
    }
  }
}