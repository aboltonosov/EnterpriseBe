﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
	|ИспользоватьПослеКомпоновкиМакета,
	|ИспользоватьПослеВыводаРезультата,
	|ИспользоватьДанныеРасшифровки,
	|ИспользоватьПриВыводеЗаголовка",
	Истина, Истина, Истина, Ложь,Истина);
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ВысотаШапки",Результат.ВысотаТаблицы); 
	
КонецПроцедуры

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Справка-расчет распределения прибыли по бюджетам субъектов РФ %1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			ПараметрыОтчета.НачалоПериода,
			ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоГода(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоГода", НачалоГода(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоГода", НачалоГода(ТекущаяДата()));
	КонецЕсли;
	
	
	ПараметрыОтчета.ПоказательНУ = Истина;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НУ");
	
	МассивСумм = Новый Массив;
	МассивСумм.Добавить("РасходыПоОплатеТруда");
	МассивСумм.Добавить("СтоимостьОСПрошлыхМесяцев");
	МассивСумм.Добавить("СтоимостьОССледующегоМесяца");
	МассивСумм.Добавить("СтоимостьОС");
	МассивСумм.Добавить("СтоимостьАмортизируемогоИмущества");
	МассивСумм.Добавить("ДоляНалоговойБазы");
	
	Таблица = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"Доли");
	ГруппировкаПериод = НайтиПоИмени(Таблица.Строки,"ГруппировкаПериодаРасчета");
	ГруппировкаИФНС   = НайтиПоИмени(Таблица.Строки,"ГруппировкаИФНС");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ПериодРасчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"КоличествоМесяцев");
	
	Для Каждого ИмяСумм Из МассивСумм Цикл
			ПодГруппа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);
		КонецЦикла;
	КонецЦикла;	
	
	Группа = ГруппировкаИФНС.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РегистрацияВНалоговомОргане");
	Для Каждого ИмяСумм Из МассивСумм Цикл
			ПодГруппа = ГруппировкаИФНС.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);
		КонецЦикла;
	КонецЦикла;	
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		ВысотаШапки = ПараметрыОтчета.ВысотаШапки;
	Иначе
		ВысотаШапки = 0;
	КонецЕсли;
	
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество() + ВысотаШапки); 
			Прервать;	
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры                                          

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли