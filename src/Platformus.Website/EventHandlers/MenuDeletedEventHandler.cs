﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.AspNetCore.Http;
using Platformus.Website.Data.Entities;
using Platformus.Website.Events;

namespace Platformus.Website.EventHandlers
{
  public class MenuDeletedEventHandler : IMenuDeletedEventHandler
  {
    public int Priority => 1000;

    public void HandleEvent(HttpContext httpContext, Menu menu)
    {
      httpContext.GetCache().RemoveMenus();
      ResponseCacheManager.RemoveAll(httpContext);
    }
  }
}