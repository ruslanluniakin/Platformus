﻿// Copyright © 2020 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Platformus.Core.Backend.ViewModels;
using Platformus.Core.Primitives;
using Platformus.Website.Backend.ViewModels.Shared;

namespace Platformus.Website.Backend.ViewModels.Endpoints
{
  public class CreateOrEditViewModel : ViewModelBase
  {
    public int? Id { get; set; }

    [Display(Name = "Name")]
    [Required]
    [StringLength(64)]
    public string Name { get; set; }

    [Display(Name = "URL template")]
    [StringLength(128)]
    public string UrlTemplate { get; set; }

    [Display(Name = "Position")]
    public int? Position { get; set; }

    [Display(Name = "Disallow anonymous")]
    [Required]
    public bool DisallowAnonymous { get; set; }

    [Display(Name = "Sign in URL")]
    [StringLength(128)]
    [RegularExpression(@"^\/$|^(\/[a-z0-9-]+)*$")]
    public string SignInUrl { get; set; }
    public IEnumerable<EndpointPermissionViewModel> EndpointPermissions { get; set; }

    [Display(Name = "Request processor C# class name")]
    [Required]
    [StringLength(128)]
    public string RequestProcessorCSharpClassName { get; set; }
    public IEnumerable<Option> RequestProcessorCSharpClassNameOptions { get; set; }
    public string RequestProcessorParameters { get; set; }

    [Display(Name = "Response cache C# class name")]
    [StringLength(128)]
    public string ResponseCacheCSharpClassName { get; set; }
    public IEnumerable<Option> ResponseCacheCSharpClassNameOptions { get; set; }
    public string ResponseCacheParameters { get; set; }
  }
}