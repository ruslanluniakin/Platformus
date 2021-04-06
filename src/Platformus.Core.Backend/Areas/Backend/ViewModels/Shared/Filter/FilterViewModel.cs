﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using Platformus.Core.Primitives;

namespace Platformus.Core.Backend.ViewModels.Shared
{
  public class FilterViewModel : ViewModelBase
  {
    public string FilteringProperty { get; set; }
    public string Title { get; set; }
    public IEnumerable<Option> Options { get; set; }
    public string Value { get; set; }
  }
}