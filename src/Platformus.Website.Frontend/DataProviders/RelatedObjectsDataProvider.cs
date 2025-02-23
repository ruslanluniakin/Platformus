﻿// Copyright © 2021 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Magicalizer.Data.Repositories.Abstractions;
using Magicalizer.Filters.Abstractions;
using Microsoft.AspNetCore.Http;
using Platformus.Core.Filters;
using Platformus.Core.Parameters;
using Platformus.Core.Primitives;
using Platformus.Website.Data.Entities;
using Platformus.Website.Filters;

namespace Platformus.Website.Frontend.DataProviders
{
  public class RelatedObjectsDataProvider : DataProviderBase
  {
    public override IEnumerable<ParameterGroup> ParameterGroups =>
      new ParameterGroup[]
      {
        new ParameterGroup(
          "General",
          new Parameter("RelationMemberId", "Relation member", ParameterEditorCodes.MemberSelector),
          new Parameter(
            "RelationType",
            "Relation type",
            Core.ParameterEditorCodes.RadioButtonList,
            new Option[]
            {
              new Option("Primary", "Primary"),
              new Option("Foreign", "Foreign")
            },
            "Primary",
            true
          )
        ),
      };

    public override string Description => "Loads objects related to the current page’s one. Supports filtering, sorting, and paging.";

    public override async Task<dynamic> GetDataAsync(HttpContext httpContext, DataSource dataSource)
    {
      ParametersParser parametersParser = new ParametersParser(dataSource.DataProviderParameters);
      Inclusion<Object>[] inclusions = null;

      if (parametersParser.GetStringParameterValue("RelationType") == "Primary")
        inclusions = new Inclusion<Object>[] {
          new Inclusion<Object>("Properties.Member"),
          new Inclusion<Object>("Properties.StringValue.Localizations"),
          new Inclusion<Object>("ForeignRelations.Primary.Properties.Member"),
          new Inclusion<Object>("ForeignRelations.Primary.Properties.StringValue.Localizations")
        };

      else inclusions = new Inclusion<Object>[] {
        new Inclusion<Object>("Properties.Member"),
        new Inclusion<Object>("Properties.StringValue.Localizations"),
        new Inclusion<Object>("PrimaryRelations.Foreign.Properties.Member"),
        new Inclusion<Object>("PrimaryRelations.Foreign.Properties.StringValue.Localizations")
      };

      Object @object = (await httpContext.GetStorage().GetRepository<int, Object, ObjectFilter>().GetAllAsync(
        new ObjectFilter(stringValue: new LocalizationFilter(value: new StringFilter(equals: httpContext.Request.GetUrlWithoutCultureSegment()))),
        inclusions: inclusions
      )).FirstOrDefault();

      if (@object == null)
        return null;

      int relationMemberId = parametersParser.GetIntParameterValue("RelationMemberId");

      if (new ParametersParser(dataSource.DataProviderParameters).GetStringParameterValue("RelationType") == "Primary")
        return @object.ForeignRelations.Where(r => r.MemberId == relationMemberId).Select(r => this.CreateViewModel(r.Primary));

      return @object.PrimaryRelations.Where(r => r.MemberId == relationMemberId).Select(r => this.CreateViewModel(r.Foreign));
    }
  }
}