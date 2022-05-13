"""This module defines ways to compute fees and taxes for real-estate."""

from dataclasses import dataclass
from datetime import datetime, timedelta

from properties.models import RealEstateAgency, RealEstateProperty


@dataclass
class Calculator:
    """Nice class use to compute various amounts."""

    real: RealEstateProperty

    def get_tax_rate(self) -> float:
        """Determine a property tax rate by browsing the internet."""

    def get_reference_rate_per_m2(self) -> float:
        """Determine a property reference rate by browsing the internet."""

    def compute_notary_fees(self) -> float:
        """Compute fees collected by notary at the sell of the property."""
        old_property = datetime.now() - self.real.build_date > timedelta(years=5)

        if old_property:
            # 7.5 à 8.5 %
            notary_fees_rate = 0.08
        else:
            # 2 à 3 %
            notary_fees_rate = 0.025

        return self.real.price * notary_fees_rate

    def compute_real_estate_agency_fees(self, agency: RealEstateAgency = None) -> float:
        """Compute fees collected by real estate agency.

        Args:
            agency: (Optional) Information on the intermediary agency that sell the real.
        """
        agency_rate = None if agency is None else agency.fees_rate
        if agency_rate is None:
            # 4 à 10 %
            agency_rate = 0.07
        return self.real.price * agency_rate

    def compute_property_tax_per_year(self) -> float:
        """Compute property tax paid by buyer during a year for a real."""
        # theoretical annual rent
        cadastral_rental_value = (
            self.get_reference_rate_per_m2() * self.real.surface * 12
        )
        # compute base is 50% of cadastral_rental_value for "built property" * 50% ie 25%
        return 0.25 * cadastral_rental_value * self.get_tax_rate()

    def compute_insurance_per_year(self) -> float:
        """Compute home insurance paid by buyer during a year."""
