long_colnames_replacements <-
  list(
    "Number of Policy" = "number.of.policy",
    "Type of Policy" = "type.of.policy",
    "Name of Policy" = "name.of.policy",
    "Year(a)" = "year.a",
    "Focus of Amendments to Policy" = "focus.of.amendments.to.policy",
    "Legislative Basis" = "legislative.basis",
    "Valid from (b)" = "valid.from.b",
    "Valid until (c)" = "valid.until.c",
    "Valid from childbirth related date (d)" = "valid.from.childbirth.related.date.d",
    "Valid until childbirth related date (e)" = "valid.until.childbirth.related.date.e",
    "Recipient" = "recipient",
    "General Functioning Structure" = "general.functioning.structure",
    "NON MONETARY ENTITLEMENTS: Types of entitlement (f)" = "non.monetary.entitlements.types.of.entitlement.f",
    "NON MONETARY ENTITLEMENTS: Period of entitlement (g)" = "non.monetary.entitlements.period.of.entitlement.g",
    "NON MONETARY ENTITLEMENTS: Length of entitlement (h)" = "non.monetary.entitlements.length.of.entitlement.h",
    "NON MONETARY ENTITLEMENTS: Conditions of entitlement Employment related conditions" = "non.monetary.entitlements.conditions.of.entitlement.employment.related.conditions",
    "NON MONETARY ENTITLEMENTS: Conditions of entitlement Conditions related to relationship to other family members" = "non.monetary.entitlements.conditions.of.entitlement.conditions.related.to.relationship.to.other.family.members",
    "NON MONETARY ENTITLEMENTS Conditions of entitlement Other entitlement conditions" = "non.monetary.entitlements.conditions.of.entitlement.other.entitlement.conditions",
    "NON MONETARY ENTITLEMENTS Other details" = "non.monetary.entitlements.other.details",
    "MONETARY ENTITLEMENTS Types of entitlement (f)" = "monetary.entitlements.types.of.entitlement.f",
    "MONETARY ENTITLEMENTS Period of entitlement" = "monetary.entitlements.period.of.entitlement",
    "MONETARY ENTITLEMENTS Length of entitlement" = "monetary.entitlements.length.of.entitlement",
    "MONETARY ENTITLEMENTS Rate of entitlement" = "monetary.entitlements.rate.of.entitlement",
    "MONETARY ENTITLEMENTS Other details" = "monetary.entitlements.other.details",
    "MONETARY ENTITLEMENTS Conditions of entitlement Age related conditions" = "monetary.entitlements.conditions.of.entitlement.age.related.conditions",
    "MONETARY ENTITLEMENTS Conditions of entitlement Employment related conditions" = "monetary.entitlements.conditions.of.entitlement.employment.related.conditions",
    "MONETARY ENTITLEMENTS Conditions of entitlement Earnings related conditions" = "monetary.entitlements.conditions.of.entitlement.earnings.related.conditions",
    "MONETARY ENTITLEMENTS Conditions of entitlement Income related conditions" = "monetary.entitlements.conditions.of.entitlement.income.related.conditions",
    "MONETARY ENTITLEMENTS Conditions of entitlement Assets savings related conditions" = "monetary.entitlements.conditions.of.entitlement.assets.savings.related.conditions",
    "MONETARY ENTITLEMENTS Conditions of entitlement Conditions related to the relationship to other family members" = "monetary.entitlements.conditions.of.entitlement.conditions.related.to.the.relationship.to.other.family.members",
    "MONETARY ENTITLEMENTS Conditions of entitlement Other entitlement conditions" = "monetary.entitlements.conditions.of.entitlement.other.entitlement.conditions",
    "Territorial application" = "territorial.application"
  )

initial_columns <- c(
  "type.of.policy",
  "name.of.policy",
  "year.a",
  "valid.from.b",
  "valid.until.c",
  "general.functioning.structure"
)

match(initial_columns, long_colnames_replacements)

colnames(timeline_data)[match(initial_columns, long_colnames_replacements)]


cols_to_show <- match(initial_columns, long_colnames_replacements)
cols_not_to_show <- setdiff(1:ncol(timeline_data), cols_to_show)

cols_not_to_show - 1


#
# displayable_columns <- c(
#   "Type.of.policy",
#   "Name.Policy",
#   "Year.a.",
#   "Focus.of.Amendments.to.Policy",
#   "Legislative.basis",
#   "Valid.from.b.",
#   "Valid.until..c...",
#   "Valid.from...childbirth.related.date..d.",
#   "Valid.until...childbirth.related.date..e..",
#   "Recipient",
#   "type...Monetary.",
#   "type..time.",
#   "type..services.",
#   "General.functioning.structure",
#   "Territorial.application"
# )

date_of_childbirth_tickbox <-
  c(
    "valid.from.childbirth.related.date.d",
    "valid.until.childbirth.related.date.e"
  )



medium_and_long_columns <- list(
  "Focus of Amendments to Policy" = "medium",
  "Legislative Basis" = "medium",
  "General Functioning Structure" = "long",
  "NON MONETARY ENTITLEMENTS: Types of entitlement (f)" = "long",
  "NON MONETARY ENTITLEMENTS: Period of entitlement (g)" = "long",
  "NON MONETARY ENTITLEMENTS: Length of entitlement (h)" = "long",
  "NON MONETARY ENTITLEMENTS: Conditions of entitlement Employment related conditions" = "long",
  "NON MONETARY ENTITLEMENTS: Conditions of entitlement Conditions related to relationship to other family members" = "long",
  "NON MONETARY ENTITLEMENTS Conditions of entitlement Other entitlement conditions" = "long",
  "NON MONETARY ENTITLEMENTS Other details" = "long",
  "MONETARY ENTITLEMENTS Types of entitlement (f)" = "long",
  "MONETARY ENTITLEMENTS Period of entitlement" = "long",
  "MONETARY ENTITLEMENTS Length of entitlement" = "long",
  "MONETARY ENTITLEMENTS Rate of entitlement" = "long",
  "MONETARY ENTITLEMENTS Other details" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Age related conditions" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Employment related conditions" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Earnings related conditions" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Income related conditions" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Assets savings related conditions" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Conditions related to the relationship to other family members" = "long",
  "MONETARY ENTITLEMENTS Conditions of entitlement Other entitlement conditions" = "long",
  "Territorial application" = "medium"
)
