BEGIN TRANSACTION;

--
-- Extension: Platformus.Core
-- Version: 3.0.0
--

INSERT INTO "Users" VALUES (1,'Administrator','2017-01-01 00:00:00.0000000');
INSERT INTO "CredentialTypes" VALUES (1,'Email','Email',1);
INSERT INTO "Credentials" VALUES (1,1,1,'admin@platformus.net','8lE3xN2Ijiv/Y/aIGwaZLrbcqrt/1jDmzPTdudKbVD0=','0O/ZGwhScZRGbsmiUEckOg==');
INSERT INTO "Roles" VALUES (1,'Developer','Developer',100);
INSERT INTO "Roles" VALUES (2,'Administrator','Administrator',200);
INSERT INTO "Roles" VALUES (3,'ContentManager','Content manager',300);
INSERT INTO "UserRoles" VALUES (1,1);
INSERT INTO "UserRoles" VALUES (1,2);
INSERT INTO "Permissions" VALUES (1,'DoAnything','Do anything',100);
INSERT INTO "Permissions" VALUES (2,'ManagePermissions','Manage permissions',200);
INSERT INTO "Permissions" VALUES (3,'ManageRoles','Manage roles',300);
INSERT INTO "Permissions" VALUES (4,'ManageUsers','Manage users',400);
INSERT INTO "Permissions" VALUES (5,'ManageConfigurations','Manage configurations',500);
INSERT INTO "Permissions" VALUES (6,'ManageCultures','Manage cultures',600);
INSERT INTO "RolePermissions" VALUES (1,1);
INSERT INTO "RolePermissions" VALUES (2,1);
INSERT INTO "Configurations" VALUES (1,'Email','Email');
INSERT INTO "Configurations" VALUES (2,'Globalization','Globalization');
INSERT INTO "Variables" VALUES (1,1,'SmtpServer','SMTP server','test',1);
INSERT INTO "Variables" VALUES (2,1,'SmtpPort','SMTP port','25',2);
INSERT INTO "Variables" VALUES (3,1,'SmtpUseSsl','SMTP use SSL','no',3);
INSERT INTO "Variables" VALUES (4,1,'SmtpLogin','SMTP login','test',4);
INSERT INTO "Variables" VALUES (5,1,'SmtpPassword','SMTP password','test',5);
INSERT INTO "Variables" VALUES (6,1,'SmtpSenderEmail','SMTP sender email','test',6);
INSERT INTO "Variables" VALUES (7,1,'SmtpSenderName','SMTP sender name','test',7);
INSERT INTO "Variables" VALUES (8,2,'SpecifyCultureInUrl','Specify culture in URL','yes',1);
INSERT INTO "Cultures" VALUES ('__','Neutral',1,0,0);
INSERT INTO "Cultures" VALUES ('en','English',0,1,1);

--
-- Extension: Platformus.Website
-- Version: 3.0.0
--

INSERT INTO "Permissions" VALUES (7,'ManageEndpoints','Manage endpoints',700);
INSERT INTO "Permissions" VALUES (8,'ManageObjects','Manage objects',800);
INSERT INTO "Permissions" VALUES (9,'ManageClasses','Manage classes',900);
INSERT INTO "Permissions" VALUES (10,'ManageMenus','Manage menus',1000);
INSERT INTO "Permissions" VALUES (11,'ManageForms','Manage forms',1100);
INSERT INTO "Permissions" VALUES (12,'ManageFileManager','Manage file manager',1200);
INSERT INTO "RolePermissions" VALUES (3,8);
INSERT INTO "RolePermissions" VALUES (3,10);
INSERT INTO "RolePermissions" VALUES (3,11);
INSERT INTO "RolePermissions" VALUES (3,12);
INSERT INTO "DataTypes" VALUES (1,'string','singleLinePlainText','Single line plain text',1);
INSERT INTO "DataTypes" VALUES (2,'string','multilinePlainText','Multiline plain text',2);
INSERT INTO "DataTypes" VALUES (3,'string','html','Html',3);
INSERT INTO "DataTypes" VALUES (4,'integer','integerNumber','Integer number',4);
INSERT INTO "DataTypes" VALUES (5,'decimal','decimalNumber','Decimal number',5);
INSERT INTO "DataTypes" VALUES (6,'integer','booleanFlag','Boolean flag',6);
INSERT INTO "DataTypes" VALUES (7,'datetime','date','Date',7);
INSERT INTO "DataTypes" VALUES (8,'datetime','dateTime','DateTime',8);
INSERT INTO "DataTypes" VALUES (9,'string','image','Image',9);
INSERT INTO "DataTypes" VALUES (10,'string','sourceCode','Source code',10);
INSERT INTO "DataTypeParameters" VALUES (1,1,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (2,1,'integerBox','MaxLength','Max length');
INSERT INTO "DataTypeParameters" VALUES (3,2,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (4,2,'integerBox','MaxLength','Max length');
INSERT INTO "DataTypeParameters" VALUES (5,4,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (6,4,'integerBox','MinValue','Min value');
INSERT INTO "DataTypeParameters" VALUES (7,4,'integerBox','MaxValue','Max value');
INSERT INTO "DataTypeParameters" VALUES (8,5,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (9,5,'integerBox','MinValue','Min value');
INSERT INTO "DataTypeParameters" VALUES (10,5,'integerBox','MaxValue','Max value');
INSERT INTO "DataTypeParameters" VALUES (11,7,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (12,8,'checkbox','IsRequired','Is required');
INSERT INTO "DataTypeParameters" VALUES (13,9,'integerBox','Width','Width');
INSERT INTO "DataTypeParameters" VALUES (14,9,'integerBox','Height','Height');
INSERT INTO "DataTypeParameters" VALUES (15,10,'textBox','Mode','Mode');
INSERT INTO "FieldTypes" VALUES (1,'TextBox','Text box',1,NULL);
INSERT INTO "FieldTypes" VALUES (2,'TextArea','Text area',2,NULL);
INSERT INTO "FieldTypes" VALUES (3,'Checkbox','Checkbox',3,NULL);
INSERT INTO "FieldTypes" VALUES (4,'RadioButtonList','Radio button list',4,NULL);
INSERT INTO "FieldTypes" VALUES (5,'DropDownList','Drop down list',5,NULL);
INSERT INTO "FieldTypes" VALUES (6,'FileUpload','File upload',6,NULL);
INSERT INTO "FieldTypes" VALUES (7,'ReCAPTCHA','ReCAPTCHA',7,'Platformus.Website.Frontend.FieldValidators.ReCaptchaFieldValidator');

--
-- Extension: Platformus.ECommerce
-- Version: 3.0.0
--

INSERT INTO "Permissions" VALUES (13,'ManageCategories','Manage categories',1300);
INSERT INTO "Permissions" VALUES (14,'ManageProducts','Manage products',1400);
INSERT INTO "Permissions" VALUES (15,'ManageOrderStates','Manage order states',1500);
INSERT INTO "Permissions" VALUES (16,'ManagePaymentMethods','Manage payment methods',1600);
INSERT INTO "Permissions" VALUES (17,'ManageDeliveryMethods','Manage delivery methods',1700);
INSERT INTO "Permissions" VALUES (18,'ManageCarts','Manage carts',1800);
INSERT INTO "Permissions" VALUES (19,'ManageOrders','Manage orders',1900);

COMMIT;