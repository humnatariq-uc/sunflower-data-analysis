# Weekly Activity 5: Functions
# 1a. Pseudocode

# Function name: should_charge_phone
# Arguments: battery_percent, leaving_soon

# IF battery is below 20%, OR
# IF leaving soon AND battery is below 50%:
#   Return "Charge your phone"
# ELSE:
#   Return "Battery is sufficient"
# End of function

# 1b. Create the function

should_charge_phone <- function(battery_percent, leaving_soon) {
  if (battery_percent < 20 || (leaving_soon && battery_percent < 50)) {
    return("Charge your phone")
  } else {
    return("Battery is sufficient")
  }
}

# Test the function
should_charge_phone(15, FALSE)
should_charge_phone(40, TRUE)
should_charge_phone(80, TRUE)