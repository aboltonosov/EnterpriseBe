﻿
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальноеЗначениеВыбора = Параметры.НачальноеЗначениеВыбора;
	
	КлючевыеСловаПериодов = Новый СписокЗначений;
	КлючевыеСловаПериодов.Добавить("Месяц", "ежемесячно");
	КлючевыеСловаПериодов.Добавить("Квартал", "ежеквартально");
	КлючевыеСловаПериодов.Добавить("Полугодие", "по полугодиям");
	КлючевыеСловаПериодов.Добавить("Год", "ежегодно");

	КромеМесяца = Новый СписокЗначений;
	КромеМесяца.Добавить(1, "января");
	КромеМесяца.Добавить(2, "февраля");
	КромеМесяца.Добавить(3, "марта");
	КромеМесяца.Добавить(4, "апреля");
	КромеМесяца.Добавить(5, "мая");
	КромеМесяца.Добавить(6, "июня");
	КромеМесяца.Добавить(7, "июля");
	КромеМесяца.Добавить(8, "августа");
	КромеМесяца.Добавить(9, "сентября");
	КромеМесяца.Добавить(10, "октября");
	КромеМесяца.Добавить(11, "ноября");
	КромеМесяца.Добавить(12, "декабря");
	
	КромеКвартала = Новый СписокЗначений;
	КромеКвартала.Добавить(1, "1-го квартала");
	КромеКвартала.Добавить(2, "2-го квартала");
	КромеКвартала.Добавить(3, "3-го квартала");
	КромеКвартала.Добавить(4, "4-го квартала");
	
	КромеПолугодия = Новый СписокЗначений;
	КромеПолугодия.Добавить(1, "1-го полугодия");
	КромеПолугодия.Добавить(2, "2-го полугодия");
	
	Кроме = Новый Структура("Месяц, Квартал, Полугодие, Год", КромеМесяца, КромеКвартала, КромеПолугодия, Новый СписокЗначений);

	ОшибкаПолученияСпискаФорм = Ложь;
	Попытка
		Попытка
			ТаблицаФормОтчета = Отчеты[НачальноеЗначениеВыбора.ИсточникОтчета].ТаблицаФормОтчета().Скопировать();
			
			КЧ = Новый КвалификаторыЧисла(1, 0);
			Массив = Новый Массив;
			Массив.Добавить(Тип("Число"));
			ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
			ТаблицаФормОтчета.Колонки.Добавить("ИндексКартинки", ОписаниеТиповЧ);
			ЗначениеВДанныеФормы(ТаблицаФормОтчета, ФормыОтчета);
		Исключение
			ОшибкаПолученияСпискаФорм = Истина;
		КонецПопытки;
		Если ОшибкаПолученияСпискаФорм Тогда
			ВызватьИсключение Неопределено;
		КонецЕсли;
		
		Для Каждого Элемент Из ФормыОтчета Цикл
						
			Если (ТекущаяДатаСеанса() > Элемент.ДатаНачалоДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаНачалоДействия)) 
			   И (ТекущаяДатаСеанса() < Элемент.ДатаКонецДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия)) Тогда
			
				Элемент.ИндексКартинки = 0;
				
			Иначе
				
				Элемент.ИндексКартинки = 1;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия) Тогда
				Элемент.ДатаКонецДействия = "По наст. время";
			КонецЕсли;
					
		КонецЦикла;
		
		ФормыОтчета.Сортировать("ДатаНачалоДействия");
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахДоступна;
	Исключение
		Элементы.ФормыОтчета.Доступность = Ложь;
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахНеДоступна;
	КонецПопытки;
	
	ИтоговаяСтрока = "";
	Периоды = НачальноеЗначениеВыбора.Периоды.Получить();
	Если Периоды <> Неопределено Тогда
		ТипЗнчПериоды = ТипЗнч(Периоды);
		Если ТипЗнчПериоды = Тип("Структура") Тогда
			ИтоговаяСтрока = ПолучитьСтрокуПредставленияПериодовДляЗаписи(Периоды);
		ИначеЕсли ТипЗнчПериоды = Тип("Соответствие") Тогда
			ТаблицаСтрокПредставлений = Новый ТаблицаЗначений;
			ТаблицаСтрокПредставлений.Колонки.Добавить("НачалоДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("КонецДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("Представление");
			Для Каждого ЗаписьПериода Из Периоды Цикл
				НовСтр = ТаблицаСтрокПредставлений.Добавить();
				НовСтр.НачалоДействия = ЗаписьПериода.Ключ;
				НовСтр.Представление = ПолучитьСтрокуПредставленияПериодовДляЗаписи(ЗаписьПериода.Значение);
			КонецЦикла;
			ТаблицаСтрокПредставлений.Сортировать("НачалоДействия");
			Для Инд = 0 По ТаблицаСтрокПредставлений.Количество() - 2 Цикл
				ТекСтр = ТаблицаСтрокПредставлений.Получить(Инд);
				СледующаяДатаНачала = ТаблицаСтрокПредставлений.Получить(Инд + 1).НачалоДействия;
				ТекСтр.КонецДействия = СледующаяДатаНачала;
			КонецЦикла;
			Для Каждого Стр Из ТаблицаСтрокПредставлений Цикл
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					Стр.КонецДействия = НачалоДня(Стр.КонецДействия - 1);
				КонецЕсли;
			КонецЦикла;
			КолСтрокТаблицыПредставлений = ТаблицаСтрокПредставлений.Количество();
			Для ОбратныйИндекс = 1 По КолСтрокТаблицыПредставлений Цикл
				Стр = ТаблицаСтрокПредставлений.Получить(КолСтрокТаблицыПредставлений - ОбратныйИндекс);
				СтрПериодДействия = "";
				Если Стр.НачалоДействия <> '00010101000000' И Стр.НачалоДействия <> Неопределено Тогда
					СтрПериодДействия = "С " + Формат(Стр.НачалоДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					СтрПериодДействия = СтрПериодДействия + " до " + Формат(Стр.КонецДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				СтрПериодДействия = СокрЛП(СтрПериодДействия);
				Если НЕ ПустаяСтрока(СтрПериодДействия) Тогда
					ИтоговаяСтрока = ИтоговаяСтрока + ВРЕГ(Лев(СтрПериодДействия, 1)) + Сред(СтрПериодДействия, 2) + ": " + нрег(Стр.Представление) + Символы.ПС;
				Иначе
					ИтоговаяСтрока = ИтоговаяСтрока + Стр.Представление + Символы.ПС;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ИтоговаяСтрока = "Сведения о возможных периодах представления не определены.";
	КонецЕсли;
	НадписьВозможныеПериоды = СокрЛП(ИтоговаяСтрока);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Функция ПолучитьСтрокуПредставленияПериодовДляЗаписи(СтруктураПериодов)
	
	ИтоговаяСтрока = "";
	МассивСтрокиПериоды = Новый Массив;
	КлючевыеСловаПериодов.ЗаполнитьПометки(Ложь);
	Для Каждого Стр Из СтруктураПериодов Цикл
		
		Ключ = Стр.Ключ;
		КлючевоеСлово = Неопределено;
		Для Каждого Эл Из КлючевыеСловаПериодов Цикл
			Если Лев(Ключ, СтрДлина(Эл.Значение)) = Эл.Значение И Эл.Пометка <> Истина Тогда
				КлючевоеСлово = Эл.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если КлючевоеСлово = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Эл.Пометка = Истина;
		Значение = Стр.Значение;
		Если Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПериоды = КлючевыеСловаПериодов.НайтиПоЗначению(КлючевоеСлово).Представление;
		ПервыйПериодИсключение = Истина;
		РазрешенныеПериоды = Новый СписокЗначений;
		РазрешенныеПериоды.ЗагрузитьЗначения(Значение);
		Для Каждого Эл Из Кроме[КлючевоеСлово] Цикл
			Если РазрешенныеПериоды.НайтиПоЗначению(Эл.Значение) = Неопределено Тогда
				СтрокаПериоды = СтрокаПериоды + ?(ПервыйПериодИсключение, ", кроме ", ", ") + Эл.Представление;
				ПервыйПериодИсключение = Ложь;
			КонецЕсли;
		КонецЦикла;
		
		ИтоговаяСтрока = ИтоговаяСтрока + СтрокаПериоды + "; ";
		
	КонецЦикла;
	
	Если ПустаяСтрока(ИтоговаяСтрока) Тогда
		ИтоговаяСтрока = "Не представляется.";
	Иначе
		ИтоговаяСтрока = Лев(ИтоговаяСтрока, СтрДлина(ИтоговаяСтрока) - 2);
		ИтоговаяСтрока = ВРег(Лев(ИтоговаяСтрока, 1)) + Сред(ИтоговаяСтрока, 2) + ".";
	КонецЕсли;
	
	Возврат ИтоговаяСтрока;
	
КонецФункции // ПолучитьСтрокуПредставленияПериодовДляЗаписи()

#КонецОбласти