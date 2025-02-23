﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using ExtCore.Infrastructure.Actions;
using Microsoft.Extensions.DependencyInjection;

namespace Platformus.Core.Backend.Actions
{
  public class AddAuthenticationAction : IConfigureServicesAction
  {
    public int Priority => 1000;

    public void Execute(IServiceCollection serviceCollection, IServiceProvider serviceProvider)
    {
      serviceCollection.AddAuthentication(BackendCookieAuthenticationDefaults.AuthenticationScheme)
        .AddCookie(BackendCookieAuthenticationDefaults.AuthenticationScheme, options =>
          {
            options.AccessDeniedPath = "/backend/account/accessdenied";
            options.LoginPath = "/backend/account/signin";
            options.LogoutPath = "/backend/account/signout";
            options.ReturnUrlParameter = "targeturl";
            options.ExpireTimeSpan = TimeSpan.FromDays(7);
          }
        );
    }
  }
}