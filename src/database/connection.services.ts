import { Injectable, OnModuleInit, OnModuleDestroy} from "@nestjs/common";
import { Pool, PoolClient } from "pg";
import { createDatabasePool } from "src/config/database.config";

@Injectable()
export class DatabaseService implements OnModuleInit, OnModuleDestroy {
    private Pool: Pool;

    async onModuleInit() {
        this.Pool = createDatabasePool();
        await this.testConnection();
        
    }
    async onModuleDestroy() {
        if(this.Pool) {
            await this.Pool.end();
        }
    }

    private async testConnection(): Promise<void> {
        try {
            const client = this.Pool.connect(); 
            await client.query('SELECT 1');
            client.release();
            console.log('Connected to database');
        } catch (error) {
            console.log('Failed to connect to database', error);
            throw error;
        }
    }
    
    async query (text: string, params?: any[]): Promise<any> {
        const client = await this.Pool.connect();
        try {
            return await client.query(text, params);
        } catch (error) {
            throw error;
        } finally {
            client.release();
        }
    }

    async getClient(): Promise<PoolClient> {
        const client = await this.Pool.connect();
        return client;
    }

    async Transaction<T> (
        callback: (client: PoolClient ) => Promise<T>,
    ): Promise<T> {
        const client = await this.Pool.connect();
        try {
            await client.query('BEGIN');
            const result = await callback(client);
            await client.query('COMMIT');
            return result;
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

}