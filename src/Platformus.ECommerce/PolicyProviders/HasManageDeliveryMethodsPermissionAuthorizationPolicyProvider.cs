﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.AspNetCore.Authorization;
using Platformus.Core;

namespace Platformus.ECommerce.PolicyProviders
{
  public class HasManageDeliveryMethodsPermissionAuthorizationPolicyProvider : Platformus.Core.IAuthorizationPolicyProvider
  {
    public string Name => Policies.HasManageDeliveryMethodsPermission;

    public AuthorizationPolicy GetAuthorizationPolicy()
    {
      AuthorizationPolicyBuilder authorizationPolicyBuilder = new AuthorizationPolicyBuilder();

      authorizationPolicyBuilder.RequireAssertion(context =>
        {
          return context.User.HasClaim(PlatformusClaimTypes.Permission, Permissions.ManageDeliveryMethods) || context.User.HasClaim(PlatformusClaimTypes.Permission, Core.Permissions.DoAnything);
        }
      );

      return authorizationPolicyBuilder.Build();
    }
  }
}