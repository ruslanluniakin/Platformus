--
-- Extension: Platformus.Core
-- Version: 3.0.0
--

-- ModelStates
CREATE TABLE [dbo].[ModelStates](
	[Id] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_ModelStates] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- Users
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Users_Name] ON [dbo].[Users] ([Name] ASC) ON [PRIMARY];

-- CredentialTypes
CREATE TABLE [dbo].[CredentialTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_CredentialTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_CredentialTypes_Code] ON [dbo].[CredentialTypes] ([Code] ASC) ON [PRIMARY];

-- Credentials
CREATE TABLE [dbo].[Credentials](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[CredentialTypeId] [int] NOT NULL,
	[Identifier] [nvarchar](64) NOT NULL,
	[Secret] [nvarchar](1024) NULL,
	[Extra] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Credentials_UserId] ON [dbo].[Credentials] ([UserId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Credentials] WITH CHECK ADD CONSTRAINT [FK_Credentials_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Credentials] WITH CHECK ADD CONSTRAINT [FK_Credentials_CredentialTypes] FOREIGN KEY ([CredentialTypeId]) REFERENCES [dbo].[CredentialTypes] ([Id]) ON DELETE CASCADE;

-- Roles
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Roles_Code] ON [dbo].[Roles] ([Code] ASC) ON [PRIMARY];

-- UserRoles
CREATE TABLE [dbo].[UserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
	CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[UserRoles] WITH CHECK ADD CONSTRAINT [FK_UserRoles_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[UserRoles] WITH CHECK ADD CONSTRAINT [FK_UserRoles_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE;

-- Permissions
CREATE TABLE [dbo].[Permissions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Permissions_Code] ON [dbo].[Permissions] ([Code] ASC) ON [PRIMARY];

-- RolePermissions
CREATE TABLE [dbo].[RolePermissions](
	[RoleId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
	CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED ([RoleId] ASC, [PermissionId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[RolePermissions] WITH CHECK ADD CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[RolePermissions] WITH CHECK ADD CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permissions] ([Id]) ON DELETE CASCADE;

-- Configurations
CREATE TABLE [dbo].[Configurations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_Configurations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Configurations_Code] ON [dbo].[Configurations] ([Code] ASC) ON [PRIMARY];

-- Variables
CREATE TABLE [dbo].[Variables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConfigurationId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Variables] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Variables_ConfigurationId] ON [dbo].[Variables]([ConfigurationId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Variables_ConfigurationId_Code] ON [dbo].[Variables] ([ConfigurationId] ASC, [Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Variables] WITH CHECK ADD CONSTRAINT [FK_Variables_Configurations] FOREIGN KEY ([ConfigurationId]) REFERENCES [dbo].[Configurations] ([Id]) ON DELETE CASCADE;

-- Cultures
CREATE TABLE [dbo].[Cultures](
	[Id] [nvarchar](2) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[IsNeutral] [bit] NOT NULL,
	[IsFrontendDefault] [bit] NOT NULL,
	[IsBackendDefault] [bit] NOT NULL,
	CONSTRAINT [PK_Cultures] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- Dictionaries
CREATE TABLE [dbo].[Dictionaries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	CONSTRAINT [PK_Dictionaries] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- Localizations
CREATE TABLE [dbo].[Localizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DictionaryId] [int] NOT NULL,
	[CultureId] [nvarchar](2) NOT NULL,
	[Value] [nvarchar](max) NULL,
	CONSTRAINT [PK_Localizations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Localizations_DictionaryId] ON [dbo].[Localizations] ([DictionaryId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Localizations_DictionaryId_CultureId] ON [dbo].[Localizations] ([CultureId] ASC, [DictionaryId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Localizations] WITH CHECK ADD CONSTRAINT [FK_Localizations_Dictionaries] FOREIGN KEY ([DictionaryId]) REFERENCES [dbo].[Dictionaries] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Localizations] WITH CHECK ADD CONSTRAINT [FK_Localizations_Cultures] FOREIGN KEY ([CultureId]) REFERENCES [dbo].[Cultures] ([Id]) ON DELETE CASCADE;

--
-- Extension: Platformus.Website
-- Version: 3.0.0
--

-- Endpoints
CREATE TABLE [dbo].[Endpoints](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[UrlTemplate] [nvarchar](128) NULL,
	[Position] [int] NULL,
	[DisallowAnonymous] [bit] NOT NULL,
	[SignInUrl] [nvarchar](128),
	[RequestProcessorCSharpClassName] [nvarchar](128) NOT NULL,
	[RequestProcessorParameters] [nvarchar](1024) NULL,
	[ResponseCacheCSharpClassName] [nvarchar](128),
	[ResponseCacheParameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Endpoints] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- EndpointPermissions
CREATE TABLE [dbo].[EndpointPermissions](
	[EndpointId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
	CONSTRAINT [PK_EndpointPermissions] PRIMARY KEY CLUSTERED ([EndpointId] ASC, [PermissionId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[EndpointPermissions] WITH CHECK ADD CONSTRAINT [FK_EndpointPermissions_Roles] FOREIGN KEY ([EndpointId]) REFERENCES [dbo].[Endpoints] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[EndpointPermissions] WITH CHECK ADD CONSTRAINT [FK_EndpointPermissions_Permissions] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permissions] ([Id]) ON DELETE CASCADE;

-- DataSources
CREATE TABLE [dbo].[DataSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EndpointId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[DataProviderCSharpClassName] [nvarchar](128) NOT NULL,
	[DataProviderParameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_DataSources] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataSources_EndpointId] ON [dbo].[DataSources] ([EndpointId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataSources] WITH CHECK ADD CONSTRAINT [FK_DataSources_Endpoints] FOREIGN KEY ([EndpointId]) REFERENCES [dbo].[Endpoints] ([Id]) ON DELETE CASCADE;

-- Classes
CREATE TABLE [dbo].[Classes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[PluralizedName] [nvarchar](64) NOT NULL,
	[IsAbstract] [bit] NOT NULL,
	CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[Classes] WITH CHECK ADD CONSTRAINT [FK_Classes_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

-- Tabs
CREATE TABLE [dbo].[Tabs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Tabs] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Tabs_ClassId] ON [dbo].[Tabs] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Tabs] WITH CHECK ADD CONSTRAINT [FK_Tabs_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

-- DataTypes
CREATE TABLE [dbo].[DataTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StorageDataType] [nvarchar](32) NOT NULL,
	[ParameterEditorCode] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_DataTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- DataTypeParameters
CREATE TABLE [dbo].[DataTypeParameters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeId] [int] NOT NULL,
	[ParameterEditorCode] [nvarchar](128) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_DataTypeParameters] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataTypeParameters_DataTypeId] ON [dbo].[DataTypeParameters] ([DataTypeId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataTypeParameters] WITH CHECK ADD CONSTRAINT [FK_DataTypeParameters_DataTypes_DataTypeId] FOREIGN KEY ([DataTypeId]) REFERENCES [dbo].[DataTypes] ([Id]) ON DELETE CASCADE;

-- DataTypeParameterOptions
CREATE TABLE [dbo].[DataTypeParameterOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeParameterId] [int] NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	CONSTRAINT [PK_DataTypeParameterOptions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataTypeParameterOptions_DataTypeParameterId] ON [dbo].[DataTypeParameterOptions] ([DataTypeParameterId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataTypeParameterOptions] WITH CHECK ADD CONSTRAINT [FK_DataTypeParameterOptions_DataTypeParameters_DataTypeParameterId] FOREIGN KEY ([DataTypeParameterId]) REFERENCES [dbo].[DataTypeParameters] ([Id]) ON DELETE CASCADE;

-- Members
CREATE TABLE [dbo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[TabId] [int] NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	[PropertyDataTypeId] [int] NULL,
	[IsPropertyLocalizable] [bit] NULL,
	[IsPropertyVisibleInList] [bit] NULL,
	[PropertyDataTypeParameters] [nvarchar](1024) NULL,
	[RelationClassId] [int] NULL,
	[IsRelationSingleParent] [bit] NULL,
	[MinRelatedObjectsNumber] [int] NULL,
	[MaxRelatedObjectsNumber] [int] NULL,
	CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Members_ClassId] ON [dbo].[Members] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Classes_ClassId] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Tabs] FOREIGN KEY ([TabId]) REFERENCES [dbo].[Tabs] ([Id]) ON DELETE SET NULL;
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_DataTypes] FOREIGN KEY ([PropertyDataTypeId]) REFERENCES [dbo].[DataTypes] ([Id]) ON DELETE SET NULL;
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Classes_RelationClassId] FOREIGN KEY ([RelationClassId]) REFERENCES [dbo].[Classes] ([Id]);

-- Objects
CREATE TABLE [dbo].[Objects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Objects_ClassId] ON [dbo].[Objects] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Objects] WITH CHECK ADD CONSTRAINT [FK_Objects_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

-- Properties
CREATE TABLE [dbo].[Properties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[IntegerValue] [int] NULL,
	[DecimalValue] [money] NULL,
	[StringValueId] [int] NULL,
	[DateTimeValue] [datetime2](7) NULL,
	CONSTRAINT [PK_Properties] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Properties_ObjectId] ON [dbo].[Properties] ([ObjectId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Properties_ObjectId_MemberId] ON [dbo].[Properties] ([ObjectId] ASC, [MemberId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Objects] FOREIGN KEY ([ObjectId]) REFERENCES [dbo].[Objects] ([Id]);
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Members] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Members] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Dictionaries] FOREIGN KEY ([StringValueId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- Relations
CREATE TABLE [dbo].[Relations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[PrimaryId] [int] NOT NULL,
	[ForeignId] [int] NOT NULL,
	CONSTRAINT [PK_Relations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Relations_PrimaryId] ON [dbo].[Relations] ([PrimaryId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_MemberId_PrimaryId] ON [dbo].[Relations] ([PrimaryId] ASC, [MemberId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_ForeignId] ON [dbo].[Relations] ([ForeignId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_MemberId_ForeignId] ON [dbo].[Relations] ([MemberId] ASC, [ForeignId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Members] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Members] ([Id]);
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Objects_PrimaryId] FOREIGN KEY ([PrimaryId]) REFERENCES [dbo].[Objects] ([Id]);
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Objects_ForeignId] FOREIGN KEY ([ForeignId]) REFERENCES [dbo].[Objects] ([Id]);

-- Menus
CREATE TABLE [dbo].[Menus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Menus_Code] ON [dbo].[Menus] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Menus] WITH CHECK ADD CONSTRAINT [FK_Menus_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- MenuItems
CREATE TABLE [dbo].[MenuItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NULL,
	[MenuItemId] [int] NULL,
	[NameId] [int] NOT NULL,
	[Url] [nvarchar](128) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_MenuItems] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_MenuItems_MenuId] ON [dbo].[MenuItems] ([MenuId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_MenuItems_MenuItemId] ON [dbo].[MenuItems] ([MenuItemId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Menus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menus] ([Id]);
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_MenuItems] FOREIGN KEY ([MenuItemId]) REFERENCES [dbo].[MenuItems] ([Id]);
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- Forms
CREATE TABLE [dbo].[Forms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[SubmitButtonTitleId] [int] NOT NULL,
	[ProduceCompletedForms] [bit] NOT NULL,
	[FormHandlerCSharpClassName] [nvarchar](128) NOT NULL,
	[FormHandlerParameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Forms] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Forms_Code] ON [dbo].[Forms] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Forms] WITH CHECK ADD CONSTRAINT [FK_Forms_Dictionaries_NameId] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Forms] WITH CHECK ADD CONSTRAINT [FK_Forms_Dictionaries_SubmitButtonTitleId] FOREIGN KEY ([SubmitButtonTitleId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- FieldTypes
CREATE TABLE [dbo].[FieldTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
  [ValidatorCSharpClassName] [nvarchar](128),
	CONSTRAINT [PK_FieldTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_FieldTypes_Code] ON [dbo].[FieldTypes] ([Code] ASC) ON [PRIMARY];

-- Fields
CREATE TABLE [dbo].[Fields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[FieldTypeId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[MaxLength] [int],
	[Position] [int] NULL,
	CONSTRAINT [PK_Fields] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Fields_FieldId] ON [dbo].[Fields] ([FormId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_Forms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[Forms] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_FieldTypes] FOREIGN KEY ([FieldTypeId]) REFERENCES [dbo].[FieldTypes] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- FieldOptions
CREATE TABLE [dbo].[FieldOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FieldId] [int] NOT NULL,
	[ValueId] [int] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_FieldOptions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_FieldOptions_FieldId] ON [dbo].[FieldOptions] ([FieldId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[FieldOptions] WITH CHECK ADD CONSTRAINT [FK_FieldOptions_Fields] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Fields] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[FieldOptions] WITH CHECK ADD CONSTRAINT [FK_FieldOptions_Dictionaries] FOREIGN KEY ([ValueId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- CompletedForms
CREATE TABLE [dbo].[CompletedForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_CompletedForms] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[CompletedForms] WITH CHECK ADD CONSTRAINT [FK_CompletedForms_Forms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[Forms] ([Id]) ON DELETE CASCADE;

-- CompletedFields
CREATE TABLE [dbo].[CompletedFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompletedFormId] [int] NOT NULL,
	[FieldId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
	CONSTRAINT [PK_CompletedFields] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

ALTER TABLE [dbo].[CompletedFields] WITH CHECK ADD CONSTRAINT [FK_CompletedFields_CompletedForms] FOREIGN KEY ([CompletedFormId]) REFERENCES [dbo].[CompletedForms] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[CompletedFields] WITH CHECK ADD CONSTRAINT [FK_CompletedFields_Fields] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Fields] ([Id]);

-- Files
CREATE TABLE [dbo].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Size] [bigint] NOT NULL,
	CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

GO

CREATE TRIGGER [DELETE_Classes]
  ON [dbo].[Classes]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Objects WHERE ClassId IN (SELECT Id FROM DELETED);
  DELETE FROM Tabs WHERE ClassId IN (SELECT Id FROM DELETED);
  DELETE FROM Members WHERE ClassId IN (SELECT Id FROM DELETED);
  UPDATE Members SET RelationClassId = NULL WHERE RelationClassId IN (SELECT Id FROM DELETED);
  UPDATE Classes SET ClassId = NULL WHERE ClassId IN (SELECT Id FROM DELETED);
  DELETE FROM Classes WHERE Id IN (SELECT Id FROM DELETED);
END
GO

CREATE TRIGGER [DELETE_Members]
  ON [dbo].[Members]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Properties WHERE MemberId IN (SELECT Id FROM DELETED);
  DELETE FROM Relations WHERE MemberId IN (SELECT Id FROM DELETED);
  DELETE FROM Members WHERE Id IN (SELECT Id FROM DELETED);
END
GO

CREATE TRIGGER [DELETE_Objects]
  ON [dbo].[Objects]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  DELETE FROM Properties WHERE ObjectId IN (SELECT Id FROM DELETED);
  DELETE FROM Relations WHERE PrimaryId IN (SELECT Id FROM DELETED);
  DELETE FROM Relations WHERE ForeignId IN (SELECT Id FROM DELETED);
  DELETE FROM Objects WHERE Id IN (SELECT Id FROM DELETED);
END
GO

CREATE TRIGGER [DELETE_Menus]
  ON [dbo].[Menus]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  SET NOCOUNT ON;
  DELETE FROM MenuItems WHERE MenuId IN (SELECT Id FROM DELETED);
  DELETE FROM Menus WHERE Id IN (SELECT Id FROM DELETED);
END
GO

CREATE TRIGGER [DELETE_MenuItems]
  ON [dbo].[MenuItems]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  CREATE TABLE #MenuItems (Id INT PRIMARY KEY);
  WITH X AS (
    SELECT Id FROM MenuItems WHERE Id IN (SELECT Id FROM DELETED)
    UNION ALL
    SELECT MenuItems.Id FROM MenuItems INNER JOIN X ON MenuItems.MenuItemId = X.Id
  )
  INSERT INTO #MenuItems SELECT Id FROM X;
  DELETE FROM MenuItems WHERE Id IN (SELECT Id FROM #MenuItems);
END
GO

--
-- Extension: Platformus.ECommerce
-- Version: 3.0.0
--

-- Categories
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NULL,
  [Url] [nvarchar](128) NOT NULL,
	[NameId] [int] NOT NULL,
  [DescriptionId] [int] NOT NULL,
  [Position] [int] NULL,
  [TitleId] [int] NOT NULL,
	[MetaDescriptionId] [int] NOT NULL,
	[MetaKeywordsId] [int] NOT NULL,
  [ProductProviderCSharpClassName] [nvarchar](128) NOT NULL,
	[ProductProviderParameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Categories_CategoryId] ON [dbo].[Categories] ([CategoryId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]);
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Dictionaries_DescriptionId] FOREIGN KEY ([DescriptionId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Dictionaries_TitleId] FOREIGN KEY ([TitleId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Dictionaries_MetaDescriptionId] FOREIGN KEY ([MetaDescriptionId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Categories] WITH CHECK ADD CONSTRAINT [FK_Categories_Dictionaries_MetaKeywordsId] FOREIGN KEY ([MetaKeywordsId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- Products
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[Url] [nvarchar](128) NOT NULL,
	[Code] [nvarchar](64) NULL,
	[NameId] [int] NOT NULL,
	[DescriptionId] [int] NOT NULL,
  [UnitsId] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[TitleId] [int] NOT NULL,
	[MetaDescriptionId] [int] NOT NULL,
	[MetaKeywordsId] [int] NOT NULL,
	CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products] ([CategoryId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_NameId] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_DescriptionId] FOREIGN KEY ([DescriptionId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_UnitsId] FOREIGN KEY ([UnitsId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_TitleId] FOREIGN KEY ([TitleId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_MetaDescriptionId] FOREIGN KEY ([MetaDescriptionId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Dictionaries_MetaKeywordsId] FOREIGN KEY ([MetaKeywordsId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- Photos
CREATE TABLE [dbo].[Photos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Filename] [nvarchar](128) NOT NULL,
	[IsCover] [bit] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Photos] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Photos_ProductId] ON [dbo].[Photos] ([ProductId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Photos] WITH CHECK ADD CONSTRAINT [FK_Photos_Products] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products] ([Id]) ON DELETE CASCADE;

-- OrderStates
CREATE TABLE [dbo].[OrderStates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_OrderStates] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[OrderStates] WITH CHECK ADD CONSTRAINT [FK_OrderStates_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- PaymentMethods
CREATE TABLE [dbo].[PaymentMethods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_PaymentMethods] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[PaymentMethods] WITH CHECK ADD CONSTRAINT [FK_PaymentMethods_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- DeliveryMethods
CREATE TABLE [dbo].[DeliveryMethods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_DeliveryMethods] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[DeliveryMethods] WITH CHECK ADD CONSTRAINT [FK_DeliveryMethods_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

-- Carts
CREATE TABLE [dbo].[Carts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientSideId] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_Carts] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

-- Orders
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderStateId] [int] NOT NULL,
	[PaymentMethodId] [int] NOT NULL,
	[DeliveryMethodId] [int] NOT NULL,
	[CustomerFirstName] [nvarchar](64) NOT NULL,
	[CustomerLastName] [nvarchar](64) NULL,
	[CustomerPhone] [nvarchar](32) NOT NULL,
	[CustomerEmail] [nvarchar](64) NULL,
	[CustomerAddress] [nvarchar](128) NULL,
	[Note] [nvarchar](1024) NULL,
	[Created] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Orders_OrderStateId] ON [dbo].[Orders] ([OrderStateId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Orders_PaymentMethodId] ON [dbo].[Orders] ([PaymentMethodId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Orders_DeliveryMethodId] ON [dbo].[Orders] ([DeliveryMethodId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_OrderStates] FOREIGN KEY ([OrderStateId]) REFERENCES [dbo].[OrderStates] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_PaymentMethods] FOREIGN KEY ([PaymentMethodId]) REFERENCES [dbo].[PaymentMethods] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_DeliveryMethods] FOREIGN KEY ([DeliveryMethodId]) REFERENCES [dbo].[DeliveryMethods] ([Id]) ON DELETE CASCADE;

-- Positions
CREATE TABLE [dbo].[Positions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CartId] [int],
	[OrderId] [int],
	[ProductId] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Quantity] [money] NOT NULL,
	CONSTRAINT [PK_Positions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Positions_CartId] ON [dbo].[Positions] ([CartId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Positions_OrderId] ON [dbo].[Positions] ([OrderId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Positions_ProductId] ON [dbo].[Positions] ([ProductId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Positions] WITH CHECK ADD CONSTRAINT [FK_Positions_Carts] FOREIGN KEY ([CartId]) REFERENCES [dbo].[Carts] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Positions] WITH CHECK ADD CONSTRAINT [FK_Positions_Orders] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders] ([Id]) ON DELETE CASCADE;
ALTER TABLE [dbo].[Positions] WITH CHECK ADD CONSTRAINT [FK_Positions_Products] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products] ([Id]) ON DELETE CASCADE;

GO

CREATE TRIGGER [DELETE_Categories]
  ON [dbo].[Categories]
   INSTEAD OF DELETE
AS 
BEGIN
  SET NOCOUNT ON;
  CREATE TABLE #Categories (Id INT PRIMARY KEY);
  WITH X AS (
    SELECT Id FROM Categories WHERE Id IN (SELECT Id FROM DELETED)
    UNION ALL
    SELECT Categories.Id FROM Categories INNER JOIN X ON Categories.CategoryId = X.Id
  )
  INSERT INTO #Categories SELECT Id FROM X;
  DELETE FROM Categories WHERE Id IN (SELECT Id FROM #Categories);
END
GO