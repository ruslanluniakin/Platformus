﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Magicalizer.Filters.Abstractions;
using Platformus.Core.Filters;

namespace Platformus.Website.Filters
{
  public class FormFilter : IFilter
  {
    public int? Id { get; set; }
    public string Code { get; set; }

    [FilterShortcut("Name.Localizations[]")]
    public LocalizationFilter Name { get; set; }
  }
}