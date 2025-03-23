// src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AdminModule } from './admin/admin.module';
import { AppController } from './app.controller';
import { AuthModule } from './auth/auth.module';
import { PrismaModule } from './prisma/prisma.module';
import { JobsModule } from './jobs/jobs.module';
import { AppService } from './app.service';
import { DriverModule } from './driver/driver.module';
import { CalendarModule } from './calendar/calendar.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { DriverRankingModule } from './driver-ranking/driver-ranking.module';
import { DriverAvailabilityModule } from './driver-availability/driver-availability.module';
import { NotificationsModule } from './notifications/notifications.module';
import { NotificationsController } from './notifications/notifications.controller';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // Makes ConfigModule available globally
    }),
    DriverModule,
    PrismaModule,
    AdminModule,
    AuthModule,
    JobsModule,
    CalendarModule,
    DashboardModule,
    DriverRankingModule,
    DriverAvailabilityModule,
    NotificationsModule
  ],
  controllers: [AppController, NotificationsController],
  providers: [AppService],
})
export class AppModule {}