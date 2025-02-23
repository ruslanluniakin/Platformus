﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.Core.Backend.ViewModels;

namespace Platformus.ECommerce.Backend.ViewModels.Shared
{
  public class PositionViewModel : ViewModelBase
  {
    public int Id { get; set; }
    public ProductViewModel Product { get; set; }
    public decimal Price { get; set; }
    public decimal Quantity { get; set; }
    public decimal Subtotal { get; set; }
  }
}