<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\VolController;
use App\Http\Controllers\Api\V1\HotelController;
use App\Http\Controllers\Api\V1\ReservationController;
use App\Http\Controllers\Api\V1\PaymentController;
use App\Http\Controllers\Api\V1\DestinationController;
use App\Http\Controllers\Api\V1\GuideController;

Route::prefix('v1')->group(function () {

    // ── Auth (public) ─────────────────────────────────────────────────────
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);

    // ── Public browsing ───────────────────────────────────────────────────
    Route::apiResource('destinations', DestinationController::class)->only(['index', 'show']);
    Route::apiResource('guides',       GuideController::class)->only(['index', 'show']);
    Route::apiResource('vols',         VolController::class)->only(['index', 'show']);
    Route::apiResource('hotels',       HotelController::class)->only(['index', 'show']);

    // ── Authenticated ─────────────────────────────────────────────────────
    Route::middleware('auth:api')->group(function () {

        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me',      [AuthController::class, 'me']);

        Route::apiResource('reservations', ReservationController::class);
        Route::get('reservations/{reservation}/ticket',
            [ReservationController::class, 'ticket']);

        Route::post('payments/process',  [PaymentController::class, 'process']);
        Route::get('payments/{payment}', [PaymentController::class, 'show']);

        // ── Admin only ────────────────────────────────────────────────────
        Route::middleware('admin')->prefix('admin')->group(function () {
            Route::apiResource('destinations', DestinationController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('guides', GuideController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('vols', VolController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('hotels', HotelController::class)
                ->only(['store', 'update', 'destroy']);
        });
    });
});
