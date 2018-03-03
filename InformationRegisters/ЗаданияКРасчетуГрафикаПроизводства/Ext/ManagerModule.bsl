﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет записи в регистр.
//
// Параметры:
//  Этапы - ДокументСсылка.ЭтапПроизводства2_2, Массив - этапы,
//		для которых необходимо добавить записи.
//
Процедура ДобавитьЗадания(Этапы) Экспорт
	
	НомерЗадания = Константы.НомерЗаданияКРасчетуГрафикаПроизводства.Получить();
	
	НачатьТранзакцию();
	
	Попытка
		
		ПараметрыБлокировки	= Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрСведений", "ЗаданияКРасчетуГрафикаПроизводства");
		ЗначенияБлокировки	= Новый Структура("НомерЗадания", НомерЗадания);
		ОбщегоНазначенияБПВызовСервера.УстановитьУправляемуюБлокировку(ПараметрыБлокировки, ЗначенияБлокировки);
	
		Если ТипЗнч(Этапы) = Тип("Массив") И Этапы.Количество() > 1 Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЗаданияКРасчетуГрафикаПроизводства.Распоряжение,
			|	ЗаданияКРасчетуГрафикаПроизводства.ЭтапПроизводства,
			|	ЗаданияКРасчетуГрафикаПроизводства.НомерЗадания
			|ИЗ
			|	РегистрСведений.ЗаданияКРасчетуГрафикаПроизводства КАК ЗаданияКРасчетуГрафикаПроизводства
			|ГДЕ
			|	ЗаданияКРасчетуГрафикаПроизводства.НомерЗадания = &НомерЗадания
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ЭтапПроизводства2_2.Распоряжение,
			|	ЭтапПроизводства2_2.Ссылка,
			|	&НомерЗадания
			|ИЗ
			|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
			|ГДЕ
			|	ЭтапПроизводства2_2.Ссылка В(&Этапы)");
			Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
			Запрос.УстановитьПараметр("Этапы", Этапы);
			ЗаданияПоНомеру = Запрос.Выполнить().Выгрузить();
			
			Набор = РегистрыСведений.ЗаданияКРасчетуГрафикаПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.НомерЗадания.Установить(НомерЗадания);
			Набор.Загрузить(ЗаданияПоНомеру);
			Набор.Записать();
			
		Иначе
			
			Если ТипЗнч(Этапы) = Тип("ДокументСсылка.ЭтапПроизводства2_2") Тогда
				ЭтапПроизводства = Этапы;
			ИначеЕсли ТипЗнч(Этапы) = Тип("Массив") И Этапы.Количество() = 1 Тогда
				ЭтапПроизводства = Этапы[0];
			Иначе
				ЭтапПроизводства = Неопределено;
			КонецЕсли;
			
			Если НЕ ЭтапПроизводства = Неопределено Тогда
				
				Менеджер = РегистрыСведений.ЗаданияКРасчетуГрафикаПроизводства.СоздатьМенеджерЗаписи();
				Менеджер.Распоряжение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтапПроизводства, "Распоряжение");
				Менеджер.ЭтапПроизводства = ЭтапПроизводства;
				Менеджер.НомерЗадания = НомерЗадания;
				Менеджер.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Добавление заданий к расчету графика производства'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
  		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Удаляет записи из регистра.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - распоряжение,
//		которому принадлежат этапы (см. параметр Этапы).
//  Этапы - ДокументСсылка.ЭтапПроизводства2_2, Массив - этапы,
//		записи по которым необходимо удалить.
//  НомерЗадания - Число - при очистке будут удалены записи с номерами заданий, меньше либо равными
//		значению параметра. Если параметр не задан, то будут удалены все записи.
//
Процедура УдалитьЗадания(Распоряжение, Этапы, НомерЗадания = Неопределено) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		ПараметрыБлокировки	= Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрСведений", "ЗаданияКРасчетуГрафикаПроизводства");
		ЗначенияБлокировки	= Новый Структура("Распоряжение", Распоряжение);
		ОбщегоНазначенияБПВызовСервера.УстановитьУправляемуюБлокировку(ПараметрыБлокировки, ЗначенияБлокировки);
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаданияКРасчетуГрафикаПроизводства.Распоряжение КАК Распоряжение,
		|	ЗаданияКРасчетуГрафикаПроизводства.ЭтапПроизводства КАК ЭтапПроизводства,
		|	ЗаданияКРасчетуГрафикаПроизводства.НомерЗадания КАК НомерЗадания
		|ПОМЕСТИТЬ ВТВсеЗадания
		|ИЗ
		|	РегистрСведений.ЗаданияКРасчетуГрафикаПроизводства КАК ЗаданияКРасчетуГрафикаПроизводства
		|ГДЕ
		|	ЗаданияКРасчетуГрафикаПроизводства.Распоряжение = &Распоряжение
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	ЭтапПроизводства,
		|	НомерЗадания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТВсеЗадания.Распоряжение КАК Распоряжение,
		|	ВТВсеЗадания.ЭтапПроизводства КАК ЭтапПроизводства,
		|	ВТВсеЗадания.НомерЗадания КАК НомерЗадания
		|ПОМЕСТИТЬ ВТЗаданияУдалить
		|ИЗ
		|	ВТВсеЗадания КАК ВТВсеЗадания
		|ГДЕ
		|	ВТВсеЗадания.ЭтапПроизводства В(&Этапы)
		|	И ВТВсеЗадания.НомерЗадания <= &НомерЗадания
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	ЭтапПроизводства,
		|	НомерЗадания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТВсеЗадания.Распоряжение,
		|	ВТВсеЗадания.ЭтапПроизводства,
		|	ВТВсеЗадания.НомерЗадания
		|ИЗ
		|	ВТВсеЗадания КАК ВТВсеЗадания
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаданияУдалить КАК ВТЗаданияУдалить
		|		ПО ВТВсеЗадания.Распоряжение = ВТЗаданияУдалить.Распоряжение
		|			И ВТВсеЗадания.ЭтапПроизводства = ВТЗаданияУдалить.ЭтапПроизводства
		|			И ВТВсеЗадания.НомерЗадания = ВТЗаданияУдалить.НомерЗадания
		|ГДЕ
		|	ВТЗаданияУдалить.Распоряжение ЕСТЬ NULL");
		
		Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
		
		Запрос.УстановитьПараметр("Этапы", Этапы);
		
		Если НомерЗадания = Неопределено Тогда
			НомерЗадания = Константы.НомерЗаданияКРасчетуГрафикаПроизводства.Получить();
		КонецЕсли;
		Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
		
		Задания = Запрос.Выполнить().Выгрузить();
		
		Набор = РегистрыСведений.ЗаданияКРасчетуГрафикаПроизводства.СоздатьНаборЗаписей();
		Набор.Отбор.Распоряжение.Установить(Распоряжение);
		Набор.Загрузить(Задания);
		Набор.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Удаление заданий к расчету графика производства'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
  		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Возвращает флаг актуальности графика этапа производства.
//
// Параметры:
//  ЭтапПроизводства - ДокументСсылка.ЭтапПроизводства2_2 - этап,
//		актуальность графика которого необходимо проверить.
// 
// Возвращаемое значение:
//  Булево - актуальность графика этапа.
//
Функция ГрафикЭтапаАктуален(ЭтапПроизводства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаданияКРасчетуГрафикаПроизводства.ЭтапПроизводства
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуГрафикаПроизводства КАК ЗаданияКРасчетуГрафикаПроизводства
	|ГДЕ
	|	ЗаданияКРасчетуГрафикаПроизводства.ЭтапПроизводства = &ЭтапПроизводства");
	Запрос.УстановитьПараметр("ЭтапПроизводства", ЭтапПроизводства);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли