﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using Platformus.Core.Backend.ViewModels;
using Platformus.ECommerce.Backend.ViewModels.Shared;

namespace Platformus.ECommerce.Backend.ViewModels.ECommerce
{
  public class ProductSelectorFormViewModel : ViewModelBase
  {
    public IEnumerable<ProductViewModel> Products { get; set; }
    public int? ProductId { get; set; }
  }
}