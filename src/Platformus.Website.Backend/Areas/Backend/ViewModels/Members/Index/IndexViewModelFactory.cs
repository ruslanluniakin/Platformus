﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Localization;
using Platformus.Core.Backend.ViewModels.Shared;
using Platformus.Core.Extensions;
using Platformus.Website.Backend.ViewModels.Shared;
using Platformus.Website.Data.Entities;
using Platformus.Website.Filters;

namespace Platformus.Website.Backend.ViewModels.Members
{
  public static class IndexViewModelFactory
  {
    public static IndexViewModel Create(HttpContext httpContext, MemberFilter filter, IEnumerable<Member> members, string orderBy, int skip, int take, int total)
    {
      IStringLocalizer<IndexViewModel> localizer = httpContext.GetStringLocalizer<IndexViewModel>();

      return new IndexViewModel()
      {
        Filter = filter,
        Grid = GridViewModelFactory.Create(
          httpContext,
          FilterViewModelFactory.Create(httpContext, "Name.Contains", localizer["Name"]),
          orderBy, skip, take, total,
          new[] {
            GridColumnViewModelFactory.Create(localizer["Name"], "Name"),
            GridColumnViewModelFactory.Create(localizer["Property Data Type"]),
            GridColumnViewModelFactory.Create(localizer["Relation Class"]),
            GridColumnViewModelFactory.Create(localizer["Position"], "Position"),
            GridColumnViewModelFactory.CreateEmpty()
          },
          members.Select(MemberViewModelFactory.Create),
          "_Member"
        )
      };
    }
  }
}