import { Body, Controller, HttpCode, HttpStatus, Post, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from '../admin/guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(
    @Body() loginDto: { emailOrUsername: string; password: string; fcmToken?: string },
  ) {
    return this.authService.login(loginDto.emailOrUsername, loginDto.password, loginDto.fcmToken);
  }
  
  @Post('update-fcm-token')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async updateFcmToken(
    @Request() req,
    @Body() data: { fcmToken: string },
  ) {
    return this.authService.updateFcmToken(req.user.sub, data.fcmToken);
  }
} 