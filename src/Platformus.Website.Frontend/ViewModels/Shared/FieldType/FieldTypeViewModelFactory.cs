﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.Website.Data.Entities;

namespace Platformus.Website.Frontend.ViewModels.Shared
{
  public static class FieldTypeViewModelFactory
  {
    public static FieldTypeViewModel Create(FieldType fieldType)
    {
      return new FieldTypeViewModel()
      {
        Code = fieldType.Code,
        Name = fieldType.Name
      };
    }
  }
}