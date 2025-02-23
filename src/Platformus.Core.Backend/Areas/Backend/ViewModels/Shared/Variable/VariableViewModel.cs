﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

namespace Platformus.Core.Backend.ViewModels.Shared
{
  public class VariableViewModel : ViewModelBase
  {
    public int Id { get; set; }
    public int ConfigurationId { get; set; }
    public string Name { get; set; }
    public string Value { get; set; }
  }
}