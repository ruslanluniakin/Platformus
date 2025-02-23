﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Magicalizer.Data.Repositories.Abstractions;
using Microsoft.AspNetCore.Mvc;
using Platformus.ECommerce.Data.Entities;
using Platformus.ECommerce.Filters;
using Platformus.ECommerce.Frontend.ViewModels.Shared;

namespace Platformus.ECommerce.Frontend.ViewComponents
{
  public class PositionsViewComponent : ViewComponent
  {
    private const string cartId = "cart_id";
    private IStorage storage;

    public PositionsViewComponent(IStorage storage)
    {
      this.storage = storage;
    }

    public async Task<IViewComponentResult> InvokeAsync(string partialViewName = "_Positions", string additionalCssClass = null)
    {
      IEnumerable<Position> positions = null;
      
      if (!string.IsNullOrEmpty(this.Request.Cookies[cartId]) && Guid.TryParse(this.Request.Cookies[cartId], out Guid clientSideId))
        positions = (await this.storage.GetRepository<int, Position, PositionFilter>().GetAllAsync(
          new PositionFilter(cart: new CartFilter(clientSideId: clientSideId)),
          inclusions: new Inclusion<Position>[] {
            new Inclusion<Position>(p => p.Product.Name.Localizations),
            new Inclusion<Position>(p => p.Product.Units.Localizations),
            new Inclusion<Position>(p => p.Product.Photos)
          }
        ));

      return this.View(PositionsViewModelFactory.Create(positions, partialViewName, additionalCssClass));
    }
  }
}