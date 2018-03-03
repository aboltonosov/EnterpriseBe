﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Ложь);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПередВыводомЭлементаРезультата", Ложь);

	Возврат Результат;

КонецФункции
// Формирует текст, выводимый в заголовке отчёта.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  ОрганизацияВНачале - Булево - флаг, используемый для вывода представления организации в начале текста,
//                                если организацию нужно выводить в тексте заголовка.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учётом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Шахматная ведомость %1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "СуммаОборот");
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВыводитьЗабалансовыеСчета", ПараметрыОтчета.ВыводитьЗабалансовыеСчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПоСубсчетам", ПараметрыОтчета.ПоСубсчетам);
	
	// Формирование структуры отчета
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	ГруппировкаСтрока = Таблица.Строки.Добавить();
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		ГруппировкаСтрока.Имя = "СтрокиВалюта";
	КонецЕсли;
	
	ПолеГруппировки = ГруппировкаСтрока.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("СчетДт");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	ГруппировкаСтрока.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаСтрока.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
	// Установка отбора на выводимый уровень иерархии счета
	ГруппаЭлементовОтбора = ГруппировкаСтрока.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
	ГруппаЭлементовОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "ПараметрыДанных.ПоСубсчетам", Истина);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "СистемныеПоля.УровеньВГруппировке", 1);
	// Отключим вывод отборов
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(ГруппировкаСтрока, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		ГруппировкаСтрокаВалюта = ГруппировкаСтрока.Структура.Добавить();
		ГруппировкаСтрокаВалюта.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ГруппировкаСтрокаВалюта.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		ПолеГруппировки = ГруппировкаСтрокаВалюта.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("ВалютаДт"); 
	КонецЕсли;
	
	ГруппировкаКолонка = Таблица.Колонки.Добавить();
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		ГруппировкаКолонка.Имя = "КолонкиВалюта";
	КонецЕсли;
	
	ПолеГруппировки = ГруппировкаКолонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("СчетКт");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	ГруппировкаКолонка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКолонка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	// Установка отбора на выводимый уровень иерархии счета
	ГруппаЭлементовОтбора = ГруппировкаКолонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
	ГруппаЭлементовОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "ПараметрыДанных.ПоСубсчетам", Истина);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "СистемныеПоля.УровеньВГруппировке", 1);
	// Отключим вывод отборов
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(ГруппировкаКолонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		ГруппировкаКолонкаВалюта = ГруппировкаКолонка.Структура.Добавить();
		ГруппировкаКолонкаВалюта.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ГруппировкаКолонкаВалюта.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		ПолеГруппировки = ГруппировкаКолонкаВалюта.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("ВалютаКт"); 
	КонецЕсли;

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
		
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		Если ТипЗнч(МакетШапкиОтчета) = Тип("ОписаниеМакетаОбластиМакетаКомпоновкиДанных")
			И МакетШапкиОтчета.Макет.Количество() > 1 
			И МакетШапкиОтчета.Макет[1].Ячейки.Количество() > 1 Тогда
			ЭлементыОформленияЯчейки = МакетШапкиОтчета.Макет[1].Ячейки[1].Оформление.Элементы;
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ЭлементыОформленияЯчейки, "ОбъединятьПоВертикали", Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Задает набор показателей, которые поволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного экземпляра отчета
//
// Параметры:
//  Настройки				 - Структура								 - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки)
//  Объект					 - ОтчетОбъект								 - Отчет из данных которого нудно собрать универсалные настройки
//  ДанныеРасшифровки		 - ДанныеРасшифровкиКомпоновкиДанных		 - Данные расшифровки отчета
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных  - Идентификатор расшифровки из ячейки для которой вызвана расшифровка
//  РеквизитыРасшифровки	 - Структура								 - Реквизиты отчета полученные из контекста расшифровываемой ячейки
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(Настройки, ДанныеРасшифровки, ИдентификаторРасшифровки, Объект, РеквизитыРасшифровки);
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки)
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов
//
// Параметры:
//  Правила - ТаблицаЗначений с правилами расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

	Правило = Правила.Добавить();
	Правило.Отчет = "ОтчетПоПроводкам";
	Правило.ШаблонПредставления = НСтр("ru = 'Отчет по проводкам'");
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли