import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  NotFoundException,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { BooksService } from './books.service';
import { CreateBookDto } from './Dto/create.book.dto';
import { UpdateBookDto } from './Dto/update.books.dto';
import { ApiResponse } from 'src/shared/interfaces/api-response.interface';
import { book } from './interfaces/books.interface';

@Controller('books')
export class BooksController {
  constructor(private readonly booksService: BooksService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() data: CreateBookDto): Promise<ApiResponse<book>> {
    try {
      const book = await this.booksService.create(data);
      return {
        success: true,
        message: 'Book created successfully',
        data: book,
      };
    } catch (error) {
      return {
        success: false,
        message: 'Failed to create book',
        error: error.message,
      };
    }
  }

  @Get('')
  @HttpCode(HttpStatus.OK)
  async findAllBooks(): Promise<ApiResponse<book[]>> {
    try {
      const books = await this.booksService.findAllBooks();
      return {
        success: true,
        message: 'Books found successfully',
        data: books,
      };
    } catch (error) {
      return {
        success: false,
        message: 'Failed to find books',
        error: error.message,
      };
    }
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  async findOne(@Param('id') id: number): Promise<ApiResponse<book>> {
    try {
      const book = await this.booksService.findOneBook(id);
      return {
        success: true,
        message: `Book ${id} found successfully`,
        data: book,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to find book ${id}`,
        error: error.message,
      };
    }
  }

  @Get('author/:author')
  @HttpCode(HttpStatus.OK)
  async findByauthor(
    @Param('author') author: string,
  ): Promise<ApiResponse<book[]>> {
    try {
      const books = await this.booksService.findByauthor(author);
      return {
        success: true,
        message: `Books with author ${author} found successfully`,
        data: books,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to find books with author ${author}`,
        error: error.message,
      };
    }
  }

  @Get('title/:title')
  @HttpCode(HttpStatus.OK)
  async findBytitle(
    @Param('title') title: string,
  ): Promise<ApiResponse<book[]>> {
    try {
      const books = await this.booksService.findBytitle(title);
      return {
        success: true,
        message: `Books with title ${title} found successfully`,
        data: books,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to find books with title ${title}`,
        error: error.message,
      };
    }
  }
  @Get('isbn/:isbn')
  @HttpCode(HttpStatus.OK)
  async findByisbn(@Param('isbn') isbn: string): Promise<ApiResponse<book[]>> {
    try {
      const books = await this.booksService.findByisbn(isbn);
      return {
        success: true,
        message: `Books with isbn ${isbn} found successfully`,
        data: books,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to find books with isbn ${isbn}`,
        error: error.message,
      };
    }
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  async update(
    @Param('id') id: number,
    @Body() data: UpdateBookDto,
  ): Promise<ApiResponse<book>> {
    try {
      const book = await this.booksService.updateBook(id, data);
      return {
        success: true,
        message: `Book ${id} updated successfully`,
        data: book,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to update book ${id}`,
        error: error.message,
      };
    }
  }

  @Delete(':id')
  async delete(@Param('id') id: number): Promise<ApiResponse<book>> {
    try {
      const book = await this.booksService.deleteBook(id);
      return {
        success: true,
        message: `Book ${id} deleted successfully`,
        data: book,
      };
    } catch (error) {
      return {
        success: false,
        message: `Failed to delete book ${id}`,
        error: error.message,
      };
    }
  }
}
