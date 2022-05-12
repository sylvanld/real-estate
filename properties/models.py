"""This module defines models used to handle data related to real-estate."""

from datetime import datetime


class RealEstateAgency:
    """Representation for a real-estate agency.

    Args:
        fees_rate: Percentage of fees that the real estate take on a sell.
    """

    def __init__(self, fees_rate: float):
        """Initialize RealEstateAgency."""
        self.fees_rate = fees_rate


class RealEstateProperty:
    """Representation for a real-estate property.

    Args:
        city: City where the real is located
        price: Raw price (in €) of the real before any tax/fee
        surface: Ground surface of the real in m2
        build_date: A date object that indicates when the real was built.
    """

    def __init__(self, city: str, price: int, surface: int, build_date: datetime):
        """Initialize RealEstateProperty."""
        self.city = city
        self.price = price
        self.surface = surface
        self.build_date = build_date
