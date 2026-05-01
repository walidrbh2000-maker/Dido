<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\VolController;
use App\Http\Controllers\Api\V1\HotelController;
use App\Http\Controllers\Api\V1\ReservationController;
use App\Http\Controllers\Api\V1\PaymentController;

Route::prefix('v1')->group(function () {

    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);

    Route::middleware('auth:api')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', [AuthController::class, 'me']);

        Route::apiResource('vols', VolController::class)->only(['index', 'show']);
        Route::apiResource('hotels', HotelController::class)->only(['index', 'show']);

        Route::apiResource('reservations', ReservationController::class);
        Route::get('reservations/{reservation}/ticket', [ReservationController::class, 'ticket']);

        Route::post('payments/process', [PaymentController::class, 'process']);
        Route::get('payments/{payment}', [PaymentController::class, 'show']);

        Route::middleware('admin')->prefix('admin')->group(function () {
            Route::apiResource('vols', VolController::class)->only(['store', 'update', 'destroy']);
            Route::apiResource('hotels', HotelController::class)->only(['store', 'update', 'destroy']);
        });
    });
});
