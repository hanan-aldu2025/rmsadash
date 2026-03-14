# Driver App Bloc/Cubit Implementation Plan

## Phase 1: Domain Layer
- [x] 1.1 Create OrderEntity (domain/entities/order_entity.dart)
- [x] 1.2 Fix order_model.dart import paths

## Phase 2: UseCases
- [x] 2.1 Create GetAvailableOrdersUseCase
- [x] 2.2 Create AcceptOrderUseCase  
- [x] 2.3 Create RejectOrderUseCase
- [x] 2.4 Create UpdateDriverLocationUseCase

## Phase 3: Data Layer Updates
- [x] 3.1 Update DriverOrdersDataSource (add driver location methods)
- [x] 3.2 Update DriverOrdersRepository (add new methods)
- [x] 3.3 Update DriverOrdersRepositoryImpl

## Phase 4: Cubit/Bloc Implementation
- [x] 4.1 Create DriverOrdersState (states)
- [x] 4.2 Create DriverOrdersEvent (events)
- [x] 4.3 Create DriverOrdersCubit (cubit logic)

## Phase 5: Dependency Injection
- [x] 5.1 Add required packages (get_it, geolocator, equatable, flutter_bloc)
- [x] 5.2 Create injection_container.dart

## Phase 6: UI Integration
- [x] 6.1 Create DriverOrdersList widget
- [x] 6.2 Create OrderCard widget
- [x] 6.3 Create DriverStatusWidget (Online/Offline)

## Phase 7: Next Steps
- [ ] 7.1 Run flutter pub get to resolve packages
- [ ] 7.2 Test the full flow
- [ ] 7.3 Verify Firebase integration

