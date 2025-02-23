﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.ECommerce.Data.Entities;

namespace Platformus.ECommerce.Backend.ViewModels.Shared
{
  public static class PositionViewModelFactory
  {
    public static PositionViewModel Create(Position position)
    {
      return new PositionViewModel()
      {
        Id = position.Id,
        Product = ProductViewModelFactory.Create(position.Product),
        Price = position.Price,
        Quantity = position.Quantity,
        Subtotal = position.GetSubtotal()
      };
    }
  }
}