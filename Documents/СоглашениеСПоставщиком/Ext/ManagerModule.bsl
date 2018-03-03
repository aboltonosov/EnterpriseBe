﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.СоглашениеСПоставщиком) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.СоглашениеСПоставщиком.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.СоглашениеСПоставщиком);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры


// Функция проверяет возможность установки пометки удаления у документа
//
// Параметры
//
Функция ВозможнаПометкаУдаления(Ссылка)  Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрНакопления.ГрафикПоступленияТоваров КАК ГрафикПоступленияТоваров
	|ГДЕ
	|	ГрафикПоступленияТоваров.Регистратор = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Возврат Запрос.Выполнить().Пустой();

КонецФункции

// Процедура проверяет возможность установки пометки удаления у документа
//
// Параметры
//
Процедура УстановитьПометкуУдаления(Соглашение, ПометкаУдаления)  Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашениеСПоставщиком.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СоглашениеСПоставщиком КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Соглашение = &Соглашение
	|	И СоглашениеСПоставщиком.ПометкаУдаления <> &ПометкаУдаления
	|");
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если ПометкаУдаления И Не ВозможнаПометкаУдаления(Выборка.Ссылка) Тогда

			ТекстИсключения = НСтр("ru='Ошибка при установке пометки удаления. По соглашению существуют оформленные документы'");

			ВызватьИсключение ТекстИсключения;

		КонецЕсли;

		Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли