﻿// Copyright © 2021 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Threading.Tasks;
using Magicalizer.Data.Repositories.Abstractions;
using Microsoft.AspNetCore.Http;
using Platformus.ECommerce.Data.Entities;
using Platformus.ECommerce.Filters;
using Platformus.ECommerce.Services.Abstractions;

namespace Platformus.ECommerce.Services.Defaults
{
  public class DefaultCartManager : ICartManager
  {
    private const string cartId = "cart_id";

    private IHttpContextAccessor httpContextAccessor;

    public DefaultCartManager(IHttpContextAccessor httpContextAccessor)
    {
      this.httpContextAccessor = httpContextAccessor;
    }

    public bool IsEmpty
    {
      get
      {
        return string.IsNullOrEmpty(this.httpContextAccessor.HttpContext.Request.Cookies[cartId]);
      }
    }

    public bool TryGetClientSideId(out Guid clientSideId)
    {
      clientSideId = Guid.Empty;

      if (this.IsEmpty)
        return false;

      return Guid.TryParse(this.httpContextAccessor.HttpContext.Request.Cookies[cartId], out clientSideId);
    }

    public async Task<int> GetQuantityAsync()
    {
      if (!this.IsEmpty && Guid.TryParse(this.httpContextAccessor.HttpContext.Request.Cookies[cartId], out Guid clientSideId))
        return await this.httpContextAccessor.HttpContext.GetStorage().GetRepository<int, Position, PositionFilter>().CountAsync(
          new PositionFilter(cart: new CartFilter(clientSideId: clientSideId))
        );

      return 0;
    }

    public async Task<decimal> GetTotalAsync()
    {
      if (!this.IsEmpty && Guid.TryParse(this.httpContextAccessor.HttpContext.Request.Cookies[cartId], out Guid clientSideId))
      {
        Cart cart = (await this.httpContextAccessor.HttpContext.GetStorage().GetRepository<int, Cart, CartFilter>().GetAllAsync(
          new CartFilter(clientSideId: clientSideId),
          inclusions: new Inclusion<Cart>[] {
            new Inclusion<Cart>(c => c.Positions)
          }
        )).FirstOrDefault();

        return cart?.GetTotal() ?? 0m;
      }

      return 0m;
    }
  }
}