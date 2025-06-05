import { Injectable } from '@nestjs/common';
import { book } from './interfaces/books.interface';
import { CreateBookDto } from './Dto/create.book.dto';
import { UpdateBookDto } from './Dto/update.books.dto';
import { DatabaseService } from 'src/database/connection.services';

@Injectable()
export class BooksService {
  constructor(private readonly databaseService: DatabaseService) {}

  async create(data: CreateBookDto): Promise<book> {
    try {
      const result = await this.databaseService.query(
        `INSERT INTO books(title, author, publication_year, isbn)
        VALUES ($1, $2, $3, $4)
        RETURNING *`,
        [data.title, data.author, data.publication_year, data.isbn],
      )
      if(result.rows.length === 0) {
        throw new Error('Failed to add a book')
      }
      return result.rows[0]
    } catch (error) {
      throw new Error ('connection error')
    }
    
    
  }
  async findAllBooks(data: CreateBookDto): Promise<book[]> {
    try {
      const result = await this.databaseService.query(
        `SELECT * FROM books`,
      )
      if(result.rows.length === 0) {
        throw new Error('No books found')
      }
      return result.rows
    } catch (error) {
      throw new Error ('connection error')
    }
  }

  async findOneBook(id: number): Promise<book> {
    try {
      const result = await this.databaseService.query(
        `SELECT FROM books WHERE id = $1`,
        [id]
      );
      return result.rows[0];
    } catch (error) {
      throw new Error('failed to find book');
    }
  }

  async findByauthor(author: string): Promise<book[]> {
    try {
      const result = await this.databaseService.query(
        `SELECT FROM books WHERE author = $1`,
        [author]
      );
      return result.rows;
    } catch (error) {
      throw new Error('failed to find books by author');
    }
  }

  async updateBook(id: number, data: UpdateBookDto) Promise<book>{
    try {
      const result = await this.databaseService.query(
        
      );
    }
  }
    
  
}
