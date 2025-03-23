import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async validateUser(emailOrUsername: string, password: string) {
    const user = await this.prisma.admin.findFirst({
      where: {
        OR: [
          { email: emailOrUsername },
          { username: emailOrUsername },
        ],
      },
    });

    if (user && (await bcrypt.compare(password, user.password))) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }

  async login(emailOrUsername: string, password: string, fcmToken?: string) {
    const user = await this.validateUser(emailOrUsername, password);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }
    
    // Update FCM token if provided
    if (fcmToken) {
      await this.prisma.admin.update({
        where: { id: user.id },
        data: { fcmToken },
      });
    }

    const payload = { sub: user.id, email: user.email, username: user.username };
    return {
      access_token: this.jwtService.sign(payload),
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    };
  }
  
  async updateFcmToken(adminId: number, fcmToken: string) {
    await this.prisma.admin.update({
      where: { id: adminId },
      data: { fcmToken },
    });
    
    return { success: true, message: 'FCM token updated successfully' };
  }
} 