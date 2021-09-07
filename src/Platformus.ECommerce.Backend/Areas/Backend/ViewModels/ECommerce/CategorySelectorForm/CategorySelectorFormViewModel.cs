﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using Platformus.Core.Backend;
using Platformus.Core.Backend.ViewModels;
using Platformus.ECommerce.Backend.ViewModels.Shared;

namespace Platformus.ECommerce.Backend.ViewModels.ECommerce
{
  public class CategorySelectorFormViewModel : ViewModelBase
  {
    public IEnumerable<TableTagHelper.Column> TableColumns { get; set; }
    public IEnumerable<CategoryViewModel> Categories { get; set; }
    public int? CategoryId { get; set; }
  }
}