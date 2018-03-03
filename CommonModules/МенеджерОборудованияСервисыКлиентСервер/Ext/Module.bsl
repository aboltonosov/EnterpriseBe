﻿
#Если НЕ ВебКлиент Тогда

// Функция возвращает фабрику XDTO сервиса оборудования.
//
Функция ФабрикаXDTOСервисаОборудования(ВерсияФорматаОбмена) Экспорт
	
	Пакет = ФабрикаXDTO.Пакеты.Получить(МенеджерОборудованияСервисыКлиентСервер.URIПространстваИмен(ВерсияФорматаОбмена));
	МассивПакетов = Новый Массив();
	МассивПакетов.Добавить(Пакет);
	Фабрика = Новый ФабрикаXDTO(,МассивПакетов);
	
	Возврат Фабрика;
КонецФункции

#КонецЕсли

Функция URIПространстваИмен(ВерсияФорматаОбмена = Неопределено) Экспорт
	
	Если ВерсияФорматаОбмена = 1006 Тогда
		URIПространстваИмен = "http://www.1c.ru/EquipmentService/1.0.0.6";
	ИначеЕсли ВерсияФорматаОбмена = 1007 Тогда
		URIПространстваИмен = "http://www.1c.ru/EquipmentService/1.0.0.7";
	Иначе
		URIПространстваИмен = "http://www.1c.ru/EquipmentService";
	КонецЕсли;
	
	Возврат URIПространстваИмен;
	
КонецФункции

// Функция возвращает пустую структуру настроек.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруНастроек() Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("НазваниеОрганизации", "");
	СтруктураНастроек.Вставить("ИНН", "");
	СтруктураНастроек.Вставить("Налогообложение", "");
	СтруктураНастроек.Вставить("ИспользоватьСкидки", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьБанковскиеКарты", Ложь);
	
	СтруктураНастроек.Вставить("ВидыОплаты", Новый Массив);
	СтруктураНастроек.Вставить("Налоги", Новый Массив);
	СтруктураНастроек.Вставить("КомбинацииНалогов", Новый Массив);
	СтруктураНастроек.Вставить("ВерсияФормата", 0);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Видов оплаты".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваВидыОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Наименование");
	СтруктураЗаписи.Вставить("ТипОплаты");
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруПрайсЛиста() Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Товары" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТовары() Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
	
КонецФункции

// Функция возвращает пустую структуру массива "Товары".
// Для заполнения XDTO-пакета EquipmentService.
Функция ПолучитьСтруктуруМассиваТовары() Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ПолучитьСтруктуруМассиваТовары();
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Характеристики" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваХарактеристики() Экспорт
	
	СтруктураЗаписиМассиваХарактеристики = Новый Структура;
	
	СтруктураЗаписиМассиваХарактеристики.Вставить("Код");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Наименование");
	СтруктураЗаписиМассиваХарактеристики.Вставить("ИмеетУпаковки", Ложь);
	СтруктураЗаписиМассиваХарактеристики.Вставить("Упаковки", Новый Массив());
	СтруктураЗаписиМассиваХарактеристики.Вставить("Штрихкод");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Остаток");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Цена");
	СтруктураЗаписиМассиваХарактеристики.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписиМассиваХарактеристики;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Упаковки" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваУпаковки() Экспорт
	
	СтруктураЗаписиМассиваУпаковки = Новый Структура;
	
	СтруктураЗаписиМассиваУпаковки.Вставить("Код");
	СтруктураЗаписиМассиваУпаковки.Вставить("Наименование");
	СтруктураЗаписиМассиваУпаковки.Вставить("Штрихкод");
	СтруктураЗаписиМассиваУпаковки.Вставить("Остаток");
	СтруктураЗаписиМассиваУпаковки.Вставить("Цена");
	СтруктураЗаписиМассиваУпаковки.Вставить("Коэффициент");
	СтруктураЗаписиМассиваУпаковки.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписиМассиваУпаковки;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Группы товаров" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваГруппыТоваров() Экспорт
	
	СтруктураЗаписиМассиваГруппыТоваров = Новый Структура;
	
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("Код",          "");
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("КодГруппы",    "");
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("Наименование", "");
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписиМассиваГруппыТоваров;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Типы документов".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТиповДокументов() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("ТипДокумента");
	СтруктураЗаписи.Вставить("МожноПолучать");
	СтруктураЗаписи.Вставить("МожноЗагружать");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи ответа PostDocsResponse
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруОтветаПриЗагрузке() Экспорт
	
	СтруктураОтветаПриЗагрузке = Новый Структура;
	
	СтруктураОтветаПриЗагрузке.Вставить("Успешно", Ложь);
	СтруктураОтветаПриЗагрузке.Вставить("Описание", "");
	
	Возврат СтруктураОтветаПриЗагрузке;
	
КонецФункции

// Функция возвращает пустую структуру записи ответа GetPriceListPackageResponse
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруОтветаПриВыгрузкеПакетаПрайсЛиста() Экспорт
	
	СтруктураОтветаПриЗагрузке = Новый Структура;
	
	СтруктураОтветаПриЗагрузке.Вставить("Успешно", Ложь);
	СтруктураОтветаПриЗагрузке.Вставить("ПакетПрайсЛиста", "");
	
	Возврат СтруктураОтветаПриЗагрузке;
	
КонецФункции

// Функция возвращает пустую структуру загружаемого документа.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗагружаемогоДокумента() Экспорт
	
	СтруктураЗагружаемогоДокумента = Новый Структура;
	
	СтруктураЗагружаемогоДокумента.Вставить("ТипДокумента");
	СтруктураЗагружаемогоДокумента.Вставить("Обработан");
	СтруктураЗагружаемогоДокумента.Вставить("Документы", Новый Массив);
	СтруктураЗагружаемогоДокумента.Вставить("ВерсияФормата", 0);
	СтруктураЗагружаемогоДокумента.Вставить("Отказ", Ложь);
	СтруктураЗагружаемогоДокумента.Вставить("СообщениеОбОшибке", "");
	
	Возврат СтруктураЗагружаемогоДокумента;
	
КонецФункции

// Функция возвращает пустую структуру отчета о продажах. 
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруОтчетаОПродажах() Экспорт
	
	СтруктураОтчетаОПродажах = Новый Структура;
	
	СтруктураОтчетаОПродажах.Вставить("Товары",				Новый Массив);
	СтруктураОтчетаОПродажах.Вставить("Оплаты",				Новый Массив);
	СтруктураОтчетаОПродажах.Вставить("ВскрытияТары",		Новый Массив);
	СтруктураОтчетаОПродажах.Вставить("НомерСмены",			);
	СтруктураОтчетаОПродажах.Вставить("ДатаОткрытияСмены",	);
	СтруктураОтчетаОПродажах.Вставить("ДатаЗакрытияСмены",	);
	
	Возврат СтруктураОтчетаОПродажах;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Товары" отчета о продажах.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТоварыОтчетаОПродажах() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Цена");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("Количество");
	СтруктураЗаписи.Вставить("ОтменаПродажи");
	СтруктураЗаписи.Вставить("ШтрихкодАлкогольнойПродукции");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Оплаты" отчета о продажах.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("ТипОплаты");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("КодВидаОплаты");
	СтруктураЗаписи.Вставить("ОтменаОплаты");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Вскрытия тары" отчета о продажах.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваВскрытияТары() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Дата");
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Количество");
	СтруктураЗаписи.Вставить("ШтрихкодАлкогольнойПродукции");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Комбинации налогов".
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваКомбинацииНалогов() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Ставки", Новый Массив);
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Ставки комбинаций".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваСтавкиКомбинаций() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("КодНалога");
	СтруктураЗаписи.Вставить("КодСтавки");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Налоги".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваНалоги() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Наименование");
	СтруктураЗаписи.Вставить("Ставки", Новый Массив);
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Ставки налогов".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваСтавкиНалогов() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Текст");
	СтруктураЗаписи.Вставить("Значение");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

//Функция возвращает пустую структуру отчета о проверке.
Функция ПолучитьСтруктуруОтчетаОПроверке() Экспорт
	
	СтруктураОтчетаОПроверке = Новый Структура;
	
	СтруктураОтчетаОПроверке.Вставить("Товары", Новый Массив);
	
	Возврат СтруктураОтчетаОПроверке;
	
КонецФункции

//Функция возвращает пустую структуру отчета о проверке.
Функция ПолучитьСтруктуруОтчетаОЦенниках() Экспорт
	
	СтруктураОтчетаОПроверке = Новый Структура;
	
	СтруктураОтчетаОПроверке.Вставить("Код");
	СтруктураОтчетаОПроверке.Вставить("Штрихкод");
	
	Возврат СтруктураОтчетаОПроверке;
	
КонецФункции
