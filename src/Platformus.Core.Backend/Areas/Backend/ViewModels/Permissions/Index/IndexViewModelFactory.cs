﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Platformus.Core.Backend.ViewModels.Shared;
using Platformus.Core.Data.Entities;

namespace Platformus.Core.Backend.ViewModels.Permissions
{
  public static class IndexViewModelFactory
  {
    public static IndexViewModel Create(string sorting, int offset, int limit, int total, IEnumerable<Permission> permissions)
    {
      return new IndexViewModel()
      {
        Sorting = sorting,
        Offset = offset,
        Limit = limit,
        Total = total,
        Permissions = permissions.Select(PermissionViewModelFactory.Create).ToList()
      };
    }
  }
}