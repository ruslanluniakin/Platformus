﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Platformus.Website.Data.Entities;

namespace Platformus.Website.Backend.ViewModels.Menus
{
  public static class CreateOrEditViewModelMapper
  {
    public static Menu Map(Menu menu, CreateOrEditViewModel createOrEdit)
    {
      menu.Code = createOrEdit.Code;
      return menu;
    }
  }
}