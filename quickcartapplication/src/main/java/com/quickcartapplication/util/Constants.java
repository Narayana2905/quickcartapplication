package com.quickcartapplication.util;


public class Constants {
    public static final String API_VERSION = "/api/v1";
    public static final String AUTH_BASE_URL = API_VERSION + "/auth";
    public static final String AUTH_HEADER = "Authorization";
    public static final String BEARER_PREFIX = "Bearer ";
    public static final String DEFAULT_PAGE = "0";
    public static final String DEFAULT_PAGE_SIZE = "20";
    public static final int MAX_PAGE_SIZE = 100;
    public static final String DEFAULT_SORT_BY = "id";
    public static final String DEFAULT_SORT_DIRECTION = "asc";
    public static final String CACHE_CATEGORIES = "categories";
    public static final String CACHE_PRODUCTS = "products";
    public static final String CACHE_PRODUCT_PAGE = "productPage";
    public static final String TOPIC_ORDER_PLACED = "order.placed";
    public static final String TOPIC_ORDER_CANCELLED = "order.cancelled";
    public static final String TOPIC_ORDER_UPDATED = "order.updated";
    public static final String TOPIC_PAYMENT_SUCCESS = "payment.success";
    public static final String TOPIC_PAYMENT_FAILED = "payment.failed";
    public static final String TOPIC_PAYMENT_REFUNDED = "payment.refunded";
    public static final String TOPIC_PAYMENT_COMPLETED = "payment.completed";
    public static final String TOPIC_ORDER_STATUS_CHANGED = "order.status.changed";
    public static final String TOPIC_INVENTORY_LOW = "inventory.low";
    public static final int LOW_STOCK_THRESHOLD = 10;
    public static final String SYSTEM_AUDITOR = "system";

    public static final String PRODUCTS_BASE_URL = API_VERSION + "/products";
    public static final String CARTS_BASE_URL = API_VERSION + "/carts";
    public static final String ORDERS_BASE_URL = API_VERSION + "/orders";
    public static final String PAYMENTS_BASE_URL = API_VERSION + "/payments";
    public static final String USERS_BASE_URL = API_VERSION + "/users";
}