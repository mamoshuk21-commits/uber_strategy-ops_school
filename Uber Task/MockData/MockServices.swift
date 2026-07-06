//
//  MockServices.swift
//  Uber Task
//

import Foundation

/// Full mock service catalog for the MoveLab prototype, grouped by
/// category. This stands in for a real catalog/config service.
enum MockServices {
    /// Explicit ordering for the Home quick-action grid.
    static let quickActionTitleOrder = [
        "Ride now", "Reserve ride", "Food delivery", "Grocery delivery",
        "Courier / Package", "Rental cars", "Shuttle", "Transit",
    ]

    static let rideAndMobility: [ServiceFeature] = [
        ServiceFeature(
            title: "Ride now", subtitle: "Get a ride in minutes",
            systemImage: "car.fill", category: .rideAndMobility,
            isQuickAction: true
        ),
        ServiceFeature(
            title: "Reserve ride", subtitle: "Book ahead of time",
            systemImage: "calendar.badge.clock", category: .rideAndMobility,
            badge: .scheduled, isQuickAction: true
        ),
        ServiceFeature(
            title: "Airport ride", subtitle: "Flight-tracked pickup",
            systemImage: "airplane", category: .rideAndMobility, badge: .popular
        ),
        ServiceFeature(
            title: "Taxi", subtitle: "Metered local taxi",
            systemImage: "car.2.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Economy ride", subtitle: "Affordable everyday rides",
            systemImage: "dollarsign.circle.fill", category: .rideAndMobility, badge: .popular
        ),
        ServiceFeature(
            title: "Shared ride", subtitle: "Split the cost, share the way",
            systemImage: "person.2.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Comfort", subtitle: "Newer cars, extra legroom",
            systemImage: "car.side.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Premium", subtitle: "High-end rides on demand",
            systemImage: "star.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Premium SUV", subtitle: "Extra space, premium feel",
            systemImage: "suv.side.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Extra-large group ride", subtitle: "Seats up to 6",
            systemImage: "person.3.sequence.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "XXL airport luggage ride", subtitle: "Room for extra bags",
            systemImage: "suitcase.rolling.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Electric / Green ride", subtitle: "Lower-emission vehicles",
            systemImage: "bolt.car.fill", category: .rideAndMobility, badge: .new
        ),
        ServiceFeature(
            title: "Pet-friendly ride", subtitle: "Bring your companion along",
            systemImage: "pawprint.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Car Seat ride", subtitle: "Rides with a child seat",
            systemImage: "figure.2.and.child.holdinghands", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "WAV / accessibility ride", subtitle: "Wheelchair accessible vehicles",
            systemImage: "figure.roll", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Hourly driver", subtitle: "Keep a driver for your day",
            systemImage: "clock.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Intercity", subtitle: "Travel between cities",
            systemImage: "building.2.fill", category: .rideAndMobility,
            availability: FeatureAvailability(regions: [.eu, .ukraine, .global])
        ),
        ServiceFeature(
            title: "Shuttle", subtitle: "Shared fixed-route rides",
            systemImage: "bus.fill", category: .rideAndMobility, isQuickAction: true
        ),
        ServiceFeature(
            title: "Charter / group transport", subtitle: "Book transport for a group",
            systemImage: "bus.doubledecker.fill", category: .rideAndMobility,
            availability: FeatureAvailability(userTypes: [.business, .personal])
        ),
        ServiceFeature(
            title: "Transit", subtitle: "Real-time public transit",
            systemImage: "tram.fill", category: .rideAndMobility, isQuickAction: true
        ),
        ServiceFeature(
            title: "Bikes", subtitle: "Unlock a bike nearby",
            systemImage: "bicycle", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Scooters", subtitle: "Quick rides around town",
            systemImage: "scooter", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Moto", subtitle: "Skip traffic on two wheels",
            systemImage: "moped.fill", category: .rideAndMobility,
            availability: FeatureAvailability(regions: [.india, .eu, .global])
        ),
        ServiceFeature(
            title: "Auto-rickshaw", subtitle: "Compact rides for short trips",
            systemImage: "car.rear.fill", category: .rideAndMobility,
            availability: FeatureAvailability(regions: [.india, .global])
        ),
        ServiceFeature(
            title: "Autonomous ride", subtitle: "Self-driving pilot program",
            systemImage: "antenna.radiowaves.left.and.right", category: .rideAndMobility,
            badge: .new,
            availability: FeatureAvailability(regions: [.us, .global], variants: [.travelHeavy, .control])
        ),
        ServiceFeature(
            title: "Rental cars", subtitle: "Rent by the day",
            systemImage: "key.fill", category: .rideAndMobility, isQuickAction: true
        ),
        ServiceFeature(
            title: "Business travel ride", subtitle: "Expensable business rides",
            systemImage: "briefcase.fill", category: .rideAndMobility, badge: .business,
            availability: FeatureAvailability(userTypes: [.business])
        ),
        ServiceFeature(
            title: "Ride for someone else", subtitle: "Book for a friend or family member",
            systemImage: "person.2.wave.2.fill", category: .rideAndMobility
        ),
        ServiceFeature(
            title: "Caregiver ride", subtitle: "Extra assistance included",
            systemImage: "heart.circle.fill", category: .rideAndMobility
        ),
    ]

    static let deliveryAndCommerce: [ServiceFeature] = [
        ServiceFeature(
            title: "Food delivery", subtitle: "Restaurants near you",
            systemImage: "fork.knife", category: .deliveryAndCommerce, badge: .popular,
            isQuickAction: true
        ),
        ServiceFeature(
            title: "Grocery delivery", subtitle: "Weekly groceries, delivered",
            systemImage: "cart.fill", category: .deliveryAndCommerce, badge: .promo,
            isQuickAction: true
        ),
        ServiceFeature(
            title: "Convenience store", subtitle: "Snacks and essentials fast",
            systemImage: "storefront.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Pharmacy delivery", subtitle: "Mock pharmacy ordering",
            systemImage: "cross.case.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Pet supplies", subtitle: "Food and toys for pets",
            systemImage: "pawprint.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Retail delivery", subtitle: "Shop local retail stores",
            systemImage: "bag.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Flowers / gifts", subtitle: "Same-day gifting",
            systemImage: "gift.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Pickup order", subtitle: "Skip delivery, grab it yourself",
            systemImage: "shippingbox.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Group order", subtitle: "Order together, split the bill",
            systemImage: "person.3.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Scheduled food order", subtitle: "Plan a meal ahead",
            systemImage: "calendar.badge.clock", category: .deliveryAndCommerce, badge: .scheduled
        ),
        ServiceFeature(
            title: "Deals / Sales aisle", subtitle: "Discounted picks nearby",
            systemImage: "tag.fill", category: .deliveryAndCommerce, badge: .promo
        ),
        ServiceFeature(
            title: "Reorder favorites", subtitle: "Your usual, one tap away",
            systemImage: "arrow.clockwise.circle.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Courier / Package", subtitle: "Send a package across town",
            systemImage: "box.truck.fill", category: .deliveryAndCommerce, isQuickAction: true
        ),
        ServiceFeature(
            title: "Return package", subtitle: "Hassle-free returns",
            systemImage: "arrow.uturn.left.circle.fill", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Errand pickup", subtitle: "Have something picked up for you",
            systemImage: "checklist", category: .deliveryAndCommerce
        ),
        ServiceFeature(
            title: "Business local delivery", subtitle: "Same-day delivery for teams",
            systemImage: "building.2.crop.circle.fill", category: .deliveryAndCommerce, badge: .business,
            availability: FeatureAvailability(userTypes: [.business])
        ),
    ]

    static let accountAndPlatform: [ServiceFeature] = [
        ServiceFeature(
            title: "MovePass", subtitle: "Save on every ride and order",
            systemImage: "sparkles", category: .accountAndPlatform, badge: .promo
        ),
        ServiceFeature(
            title: "Wallet", subtitle: "Manage payment methods",
            systemImage: "wallet.pass.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Promotions", subtitle: "Your active offers",
            systemImage: "tag.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Gift cards", subtitle: "Mock gift card balance",
            systemImage: "giftcard.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Invite friends", subtitle: "Share MoveLab, earn credit",
            systemImage: "person.badge.plus", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Safety center", subtitle: "Tools and resources for safer trips",
            systemImage: "shield.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Share trip", subtitle: "Let someone follow your ride",
            systemImage: "square.and.arrow.up", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Help", subtitle: "Get support",
            systemImage: "questionmark.circle.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Activity", subtitle: "Past rides and orders",
            systemImage: "clock.arrow.circlepath", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Business profile", subtitle: "Switch to a business account",
            systemImage: "briefcase.fill", category: .accountAndPlatform,
            availability: FeatureAvailability(userTypes: [.business, .personal])
        ),
        ServiceFeature(
            title: "Family profile", subtitle: "Share access with family",
            systemImage: "figure.2.and.child.holdinghands", category: .accountAndPlatform,
            availability: FeatureAvailability(userTypes: [.family, .personal])
        ),
        ServiceFeature(
            title: "Student discount", subtitle: "Mock verified student pricing",
            systemImage: "graduationcap.fill", category: .accountAndPlatform,
            availability: FeatureAvailability(userTypes: [.student])
        ),
        ServiceFeature(
            title: "Travel rewards", subtitle: "Mock points and perks",
            systemImage: "star.circle.fill", category: .accountAndPlatform,
            availability: FeatureAvailability(variants: [.travelHeavy, .control])
        ),
        ServiceFeature(
            title: "Preferences", subtitle: "Ride, language, and app settings",
            systemImage: "gearshape.fill", category: .accountAndPlatform
        ),
        ServiceFeature(
            title: "Saved places", subtitle: "Home, work, and favorites",
            systemImage: "mappin.and.ellipse", category: .accountAndPlatform
        ),
    ]

    static var all: [ServiceFeature] {
        rideAndMobility + deliveryAndCommerce + accountAndPlatform
    }
}
