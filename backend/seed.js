const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore, FieldValue, GeoPoint } = require('firebase-admin/firestore');
const { getAuth } = require('firebase-admin/auth');
const serviceAccount = require('./serviceAccountKey.json');

initializeApp({
    credential: cert(serviceAccount)
});

const db = getFirestore();
const auth = getAuth();




async function fullSeed() {
    console.log('⏳ Bắt đầu nạp toàn bộ Database lên Firestore...');

    // ==========================================
    // 1. COLLECTION: categories (Danh mục món ăn)
    // ==========================================
    console.log('-> Đang nạp categories...');
    const categories = [
        {
            categoryId: 'CAT_COM',
            name: 'Cơm',
            iconUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
            displayOrder: 1
        },
        {
            categoryId: 'CAT_BUN',
            name: 'Bún / Phở',
            iconUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43',
            displayOrder: 2
        },
        {
            categoryId: 'CAT_TRASUA',
            name: 'Trà Sữa & Đồ Uống',
            iconUrl: 'https://images.unsplash.com/photo-1558857563-b37cf5a2c418',
            displayOrder: 3
        },
        {
            categoryId: 'CAT_FASTFOOD',
            name: 'Đồ Ăn Nhanh',
            iconUrl: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330',
            displayOrder: 4
        },
        {
            categoryId: 'CAT_ANVAT',
            name: 'Ăn Vặt',
            iconUrl: 'https://images.unsplash.com/photo-1541544741938-0af808871cc0',
            displayOrder: 5
        }
    ];

    for (const cat of categories) {
        await db.collection('categories').doc(cat.categoryId).set(cat);
    }

    // ==========================================
    // 2. COLLECTION: users (Tài khoản mẫu các vai trò)
    // ==========================================
    console.log('-> Đang nạp users...');
    const users = [
        {
            uid: 'USER_CUSTOMER_01',
            name: 'Nguyễn Văn Khách',
            email: 'khach@gmail.com',
            password: 'password123',
            phone: '0987111222',
            avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            roles: ['customer'],
            activeRole: 'customer',
            defaultAddress: {
                street: 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
                latitude: 21.0090,
                longitude: 105.8280
            },
            createdAt: FieldValue.serverTimestamp()
        },
        {
            uid: 'USER_MERCHANT_01',
            name: 'Trần Văn Chủ Quán',
            email: 'chuquan@gmail.com',
            password: 'password123',
            phone: '0912333444',
            avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
            roles: ['customer', 'merchant'],
            activeRole: 'merchant',
            restaurantId: 'RES_001',
            defaultAddress: {
                street: '175 Tây Sơn, Đống Đa, Hà Nội',
                latitude: 21.0076,
                longitude: 105.8249
            },
            createdAt: FieldValue.serverTimestamp()
        },
        {
            uid: 'USER_SHIPPER_01',
            name: 'Lê Văn Tài Xế',
            email: 'taixe@gmail.com',
            password: 'password123',
            phone: '0934555666',
            avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
            roles: ['customer', 'shipper'],
            activeRole: 'shipper',
            isShipperOnline: true,
            shipperWallet: 350000,
            currentLocation: {
                latitude: 21.0080,
                longitude: 105.8260,
                updatedAt: FieldValue.serverTimestamp()
            },
            createdAt: FieldValue.serverTimestamp()
        },
        {
            uid: 'USER_ADMIN_01',
            name: 'Hệ Thống Admin',
            email: 'admin@gmail.com',
            password: 'password123',
            phone: '0999888999',
            avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
            roles: ['admin'],
            activeRole: 'admin',
            createdAt: FieldValue.serverTimestamp()
        }
    ];

    for (const user of users) {
        // Tách password ra để không lưu plaintext password vào Firestore
        const { password, ...firestoreData } = user;

        // 1. Tạo/cập nhật tài khoản trong Firebase Authentication
        try {
            await auth.createUser({
                uid: user.uid,
                email: user.email,
                password: user.password,
                displayName: user.name,
                photoURL: user.avatarUrl,
            });
            console.log(`  ✓ Đã tạo Auth: ${user.email} (${user.activeRole})`);
        } catch (err) {
            if (err.code === 'auth/uid-already-exists' || err.code === 'auth/email-already-exists') {
                await auth.updateUser(user.uid, {
                    password: user.password,
                    displayName: user.name,
                    photoURL: user.avatarUrl,
                });
                console.log(`  ↺ Đã cập nhật Auth: ${user.email} (${user.activeRole})`);
            } else {
                console.error(`  ✗ Lỗi tạo Auth ${user.email}:`, err.message);
            }
        }

        // 2. Lưu hồ sơ người dùng vào Firestore
        await db.collection('users').doc(user.uid).set(firestoreData);
    }

    // ==========================================
    // 3. COLLECTION: restaurants (Quán ăn)
    // ==========================================
    console.log('-> Đang nạp restaurants...');
    const restaurants = [
        {
            restaurantId: 'RES_001',
            ownerId: 'USER_MERCHANT_01',
            name: 'Cơm Tấm Cali - Tây Sơn',
            phone: '0901234567',
            address: '175 Tây Sơn, Trung Liệt, Đống Đa, Hà Nội',
            geo: {
                geopoint: new GeoPoint(21.0076, 105.8249),
                geohash: 'w7eyw8z'
            },
            imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
            rating: 4.8,
            totalReviews: 128,
            isOpen: true,
            createdAt: FieldValue.serverTimestamp()
        },
        {
            restaurantId: 'RES_002',
            ownerId: 'USER_MERCHANT_01',
            name: 'Trà Sữa Đô Đô - Chùa Bộc',
            phone: '0909888777',
            address: '88 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
            geo: {
                geopoint: new GeoPoint(21.0085, 105.8272),
                geohash: 'w7eywc0'
            },
            imageUrl: 'https://images.unsplash.com/photo-1558857563-b37cf5a2c418',
            rating: 4.6,
            totalReviews: 85,
            isOpen: true,
            createdAt: FieldValue.serverTimestamp()
        }
    ];

    for (const res of restaurants) {
        await db.collection('restaurants').doc(res.restaurantId).set(res);
    }

    // ==========================================
    // 4. COLLECTION: foods (Món ăn)
    // ==========================================
    console.log('-> Đang nạp foods...');
    const foods = [
        {
            foodId: 'FOOD_001',
            restaurantId: 'RES_001',
            categoryId: 'CAT_COM',
            name: 'Cơm Sườn Nướng Đặc Biệt',
            description: 'Sườn cốt lết mật ong kèm trứng ốp la, dưa chua, mỡ hành.',
            basePrice: 45000,
            imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
            isAvailable: true,
            options: {
                sizes: [
                    { name: 'Vừa (M)', price: 0 },
                    { name: 'Lớn (L)', price: 10000 }
                ],
                toppings: [
                    { name: 'Thêm trứng ốp la', price: 8000 },
                    { name: 'Thêm chả trứng', price: 10000 }
                ]
            },
            rating: 4.9,
            createdAt: FieldValue.serverTimestamp()
        },
        {
            foodId: 'FOOD_002',
            restaurantId: 'RES_001',
            categoryId: 'CAT_COM',
            name: 'Cơm Gà Xối Mỡ Giòn Rụm',
            description: 'Đùi gà góc tư chiên giòn, cơm chiên vàng thơm ngậy.',
            basePrice: 50000,
            imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
            isAvailable: true,
            options: {
                sizes: [{ name: 'Tiêu chuẩn', price: 0 }],
                toppings: [{ name: 'Thêm cơm đảo', price: 5000 }]
            },
            rating: 4.7,
            createdAt: FieldValue.serverTimestamp()
        },
        {
            foodId: 'FOOD_003',
            restaurantId: 'RES_002',
            categoryId: 'CAT_TRASUA',
            name: 'Trà Sữa Trân Châu Đường Đen',
            description: 'Sữa tươi thanh trùng Đà Lạt kết hợp trân châu thủ công dẻo dai.',
            basePrice: 35000,
            imageUrl: 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054',
            isAvailable: true,
            options: {
                sizes: [
                    { name: 'Size M', price: 0 },
                    { name: 'Size L', price: 8000 }
                ],
                toppings: [
                    { name: 'Trân châu trắng', price: 7000 },
                    { name: 'Pudding trứng', price: 9000 },
                    { name: 'Kem Cheese', price: 10000 }
                ]
            },
            rating: 4.8,
            createdAt: FieldValue.serverTimestamp()
        }
    ];

    for (const food of foods) {
        await db.collection('foods').doc(food.foodId).set(food);
    }

    // ==========================================
    // 5. COLLECTION: vouchers (Mã giảm giá)
    // ==========================================
    console.log('-> Đang nạp vouchers...');
    const vouchers = [
        {
            voucherId: 'VOUCHER_CALI10',
            merchantId: 'RES_001', // Voucher riêng của quán Cơm Cali
            code: 'CALI10',
            title: 'Giảm 10.000đ cho đơn từ 50k',
            discountType: 'fixed',
            discountValue: 10000,
            minOrderValue: 50000,
            usageLimit: 100,
            usedCount: 12,
            isActive: true,
            expiredAt: new Date('2027-12-31')
        },
        {
            voucherId: 'VOUCHER_GLOBAL20',
            merchantId: 'GLOBAL', // Voucher toàn sàn của Admin
            code: 'FREESHIP',
            title: 'Giảm 15.000đ phí giao hàng',
            discountType: 'fixed',
            discountValue: 15000,
            minOrderValue: 40000,
            usageLimit: 500,
            usedCount: 76,
            isActive: true,
            expiredAt: new Date('2027-12-31')
        }
    ];

    for (const v of vouchers) {
        await db.collection('vouchers').doc(v.voucherId).set(v);
    }

    // ==========================================
    // 6. COLLECTION: orders (Đơn hàng mẫu demo tracking)
    // ==========================================
    console.log('-> Đang nạp orders...');
    const orders = [
        {
            orderId: 'ORD_2026_001',
            customerId: 'USER_CUSTOMER_01',
            customerName: 'Nguyễn Văn Khách',
            customerPhone: '0987111222',
            deliveryAddress: {
                street: 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
                latitude: 21.0090,
                longitude: 105.8280
            },
            restaurantId: 'RES_001',
            restaurantName: 'Cơm Tấm Cali - Tây Sơn',
            restaurantAddress: '175 Tây Sơn, Trung Liệt, Đống Đa, Hà Nội',
            restaurantGeo: [21.0076, 105.8249],
            shipperId: 'USER_SHIPPER_01',
            shipperName: 'Lê Văn Tài Xế',
            shipperPhone: '0934555666',
            shipperLocation: {
                latitude: 21.0080,
                longitude: 105.8260,
                updatedAt: FieldValue.serverTimestamp()
            },
            items: [
                {
                    foodId: 'FOOD_001',
                    name: 'Cơm Sườn Nướng Đặc Biệt',
                    price: 55000,
                    quantity: 2,
                    size: 'Lớn (L)',
                    toppings: ['Thêm trứng ốp la'],
                    note: 'Nhiều dưa góp, ít mỡ hành'
                }
            ],
            foodCost: 110000,
            shippingFee: 15000,
            discountAmount: 10000,
            totalPrice: 115000,
            paymentMethod: 'COD',
            status: 'delivering', // Các mốc: pending -> preparing -> ready_for_pickup -> delivering -> completed
            createdAt: FieldValue.serverTimestamp()
        }
    ];

    for (const ord of orders) {
        await db.collection('orders').doc(ord.orderId).set(ord);
    }

    // ==========================================
    // 7. COLLECTION: partner_registrations (Hồ sơ chờ Admin duyệt)
    // ==========================================
    console.log('-> Đang nạp partner_registrations...');
    const registrations = [
        {
            requestId: 'REQ_MERCHANT_01',
            userId: 'USER_CUSTOMER_01',
            requestRole: 'merchant',
            status: 'pending', // pending -> approved -> rejected
            details: {
                shopName: 'Bún Bò Huế Ngự Uyển',
                phone: '0988776655',
                address: '22 Chùa Bộc, Đống Đa, Hà Nội',
                latitude: 21.0088,
                longitude: 105.8275,
                imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43'
            },
            createdAt: FieldValue.serverTimestamp()
        },
        {
            requestId: 'REQ_SHIPPER_01',
            userId: 'USER_CUSTOMER_01',
            requestRole: 'shipper',
            status: 'pending',
            details: {
                fullName: 'Nguyễn Văn Khách',
                idCard: '001202009876',
                vehiclePlate: '29E2-678.99',
                vehicleType: 'Honda Wave Alpha',
                licenseImageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136'
            },
            createdAt: FieldValue.serverTimestamp()
        }
    ];

    for (const req of registrations) {
        await db.collection('partner_registrations').doc(req.requestId).set(req);
    }

    console.log('\n=================================================');
    console.log('🎉 THÀNH CÔNG! Đã nạp đầy đủ 7 collections lên Firestore:');
    console.log('1. categories');
    console.log('2. users');
    console.log('3. restaurants');
    console.log('4. foods');
    console.log('5. vouchers');
    console.log('6. orders');
    console.log('7. partner_registrations');
    console.log('=================================================\n');
    process.exit(0);
}

fullSeed().catch((error) => {
    console.error('❌ Lỗi khi nạp dữ liệu:', error);
    process.exit(1);
});