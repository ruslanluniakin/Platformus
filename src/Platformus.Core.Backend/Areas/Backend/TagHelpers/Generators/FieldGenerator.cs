﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.AspNetCore.Mvc.Rendering;
using Platformus.Core.Primitives;

namespace Platformus.Core.Backend
{
  public static class FieldGenerator
  {
    public static TagBuilder GenerateLabel(string text, string identity)
    {
      TagBuilder tb = new TagBuilder(TagNames.Label);

      tb.AddCssClass("field__label label");
      tb.MergeAttribute("for", identity);
      tb.InnerHtml.AppendHtml(text);
      return tb;
    }

    public static TagBuilder GenerateRequiredMarker(string label = "required")
    {
      TagBuilder tb = new TagBuilder(TagNames.Div);

      tb.AddCssClass("field__required");
      tb.InnerHtml.AppendHtml(label);
      return tb;
    }

    public static TagBuilder GenerateCulture(Localization localization)
    {
      TagBuilder tb = new TagBuilder(TagNames.Div);

      tb.AddCssClass("field__culture culture");
      tb.InnerHtml.AppendHtml(GenerateFlag(localization));
      return tb;
    }

    public static TagBuilder GenerateFlag(Localization localization)
    {
      TagBuilder tb = new TagBuilder(TagNames.Div);

      tb.AddCssClass($"culture__flag culture__flag--{localization.Culture.Id}");
      return tb;
    }
  }
}