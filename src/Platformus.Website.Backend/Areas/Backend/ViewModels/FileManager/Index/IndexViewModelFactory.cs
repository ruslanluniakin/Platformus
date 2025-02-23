﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Platformus.Website.Backend.ViewModels.Shared;
using Platformus.Website.Data.Entities;

namespace Platformus.Website.Backend.ViewModels.FileManager
{
  public static class IndexViewModelFactory
  {
    public static IndexViewModel Create(string sorting, int offset, int limit, int total, IEnumerable<File> files)
    {
      return new IndexViewModel()
      {
        Sorting = sorting,
        Offset = offset,
        Limit = limit,
        Total = total,
        Files = files.Select(FileViewModelFactory.Create).ToList()
      };
    }
  }
}