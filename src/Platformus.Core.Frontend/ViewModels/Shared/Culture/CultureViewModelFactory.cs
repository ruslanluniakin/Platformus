﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.Core.Data.Entities;

namespace Platformus.Core.Frontend.ViewModels.Shared
{
  public static class CultureViewModelFactory
  {
    public static CultureViewModel Create(Culture culture)
    {
      return new CultureViewModel()
      {
        Id = culture.Id,
        Name = culture.Name
      };
    }
  }
}