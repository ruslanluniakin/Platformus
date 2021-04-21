﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Threading.Tasks;
using Magicalizer.Data.Repositories.Abstractions;
using Magicalizer.Filters.Abstractions;
using Microsoft.AspNetCore.Mvc;
using Platformus.Core.Frontend.ViewComponents;
using Platformus.ECommerce.Data.Entities;
using Platformus.ECommerce.Filters;
using Platformus.ECommerce.Frontend.ViewModels.Shared;

namespace Platformus.ECommerce.Frontend.ViewComponents
{
  public class CatalogViewComponent : ViewComponentBase
  {
    private ICache cache;

    public CatalogViewComponent(IStorage storage, ICache cache)
      : base(storage)
    {
      this.cache = cache;
    }

    public async Task<IViewComponentResult> InvokeAsync(string partialViewName = null, string additionalCssClass = null)
    {
      IEnumerable<Category> categories = await this.cache.GetCategoriesWithDefaultValue(
        async () => await this.Storage.GetRepository<int, Category, CategoryFilter>().GetAllAsync(
          new CategoryFilter(owner: new CategoryFilter(id: new IntegerFilter(isNull: true))),
          inclusions: new Inclusion<Category>[] {
            new Inclusion<Category>("Name.Localizations"),
            new Inclusion<Category>("Categories.Name.Localizations"),
            new Inclusion<Category>("Categories.Categories.Name.Localizations") }
        )
      );

      return this.View(new CatalogViewModelFactory().Create(this.HttpContext, categories, partialViewName, additionalCssClass));
    }
  }
}