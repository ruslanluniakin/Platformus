﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Platformus.Core.Data.Entities;

namespace Platformus.Core.Backend.ViewModels.Users
{
  public class CreateOrEditViewModelMapper : ViewModelMapperBase
  {
    public User Map(User user, CreateOrEditViewModel createOrEdit)
    {
      if (user.Id == 0)
        user.Created = DateTime.Now;

      user.Name = createOrEdit.Name;
      return user;
    }
  }
}