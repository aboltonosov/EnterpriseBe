﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает используемые аналитики статьи бюджетов, разделенные " / "
//
// Параметры:
// 	 РеквизитыСтатьиБюджетов - Структура, Выборка, СтрокаТаблицыЗначений  - реквизиты статьи бюджетов
//
// Возвращаемое значение:
// 	 Представление - Строка
//
Функция ПредставлениеАналитикСтатьиБюджетов(РеквизитыСтатьиБюджетов) Экспорт
	
	Представление = "";
	
	Для НомерАналитики = 1 По РеквизитыСтатьиБюджетов.КоличествоИспользуемыхАналитик Цикл
		Если ЗначениеЗаполнено(РеквизитыСтатьиБюджетов["ВидАналитики" + НомерАналитики]) Тогда
			Представление = Представление 
				+ ?(Представление = "", "", " / ") 
				+ РеквизитыСтатьиБюджетов["ВидАналитики" + НомерАналитики];
		КонецЕсли;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

#Область ПроцедурыИФункцииРаботыСПериодами

// Функция добавляет интервал к дате
//
// Параметры:
//	Дата          - Дата - произвольная дата
//	Периодичность - ПеречислениеСсылка.Периодичность - периодичность планирования по сценарию.
//	Смещение      - Число - определяет направление и количество периодов, в котором сдвигается дата
//	Кэш           - Соответствие - кэш добавления периодов. См. функцию БюджетированиеКлиентСервер.ПреобразоватьПараметрыДанныхВДанныеПериодов
//
// Возвращаемое значение:
//	Дата - дата, отстоящая от исходной на заданное количество периодов 
//
Функция ДобавитьИнтервал(Дата, Периодичность, Смещение, Кэш = Неопределено) Экспорт
	
	Если Кэш <> Неопределено Тогда
		ДатаВКэш = Кэш[Дата];
		Если ДатаВКэш <> Неопределено Тогда
			ПериодичностьВКэш = ДатаВКэш[Периодичность];
			Если ПериодичностьВКэш <> Неопределено Тогда
				Результат = ПериодичностьВКэш[Смещение];
				Если Результат <> Неопределено Тогда
					Возврат Результат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Смещение = 0 Тогда
		Результат = Дата;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		Результат = НачалоНеделиПоМесяцу(Дата + Смещение * 7 * 24 * 3600);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Результат = НачалоДекады(Дата + Смещение * 11 * 24 * 3600);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 3);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 6);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 12);
		
	Иначе
		Результат = НачалоДня(Дата) + Смещение * 24 * 3600;
		
	КонецЕсли;
	
	Если Кэш <> Неопределено Тогда
		
		Если Кэш[Дата] = Неопределено Тогда
			Кэш.Вставить(Дата, Новый Соответствие);
		КонецЕсли;
		
		Если Кэш[Дата][Периодичность] = Неопределено Тогда
			Кэш[Дата].Вставить(Периодичность, Новый Соответствие);
		КонецЕсли;
		
		Кэш[Дата][Периодичность].Вставить(Смещение, Результат);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//Функция добавляет заданное количество дней к дате.
//
// Параметры:
// 	Дата - Дата - Произвольная дата
// 	ЧислоДней - Число - Число дней, которые следует добавить к дате.
// 
// Возвращаемое значение:
// 	Дата - Итоговая дата.
//
Функция ДобавитьДень(Дата, ЧислоДней) Экспорт
	
	Возврат Дата + ЧислоДней * 86400; // 86400 = 24*60*60 - число секунд в дне;
	
КонецФункции 

// Функция возвращает ближайшую дату начала периода планирования.
//
// Параметры:
//	ДатаВПериоде - Дата - Произвольная дата.
//	Периодичность - Перечисления.Периодичность - Периодичность планирования по сценарию.
//
// Возвращаемое значение:
//	ДатаНачалаПериода - ближайшая дата начала периода планирования.
//
Функция ДатаНачалаПериода(ДатаВПериоде, Периодичность) Экспорт
	
	Если НЕ ТипЗнч(ДатаВПериоде) = Тип("Дата") Тогда
		Возврат '00010101';
	КонецЕсли;
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		Возврат НачалоНеделиПоМесяцу(ДатаВПериоде);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Возврат НачалоДекады(ДатаВПериоде);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		Возврат НачалоМесяца(ДатаВПериоде);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		Возврат НачалоКвартала(ДатаВПериоде);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Возврат НачалоПолугодия(ДатаВПериоде);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		Возврат НачалоГода(ДатаВПериоде);
	Иначе
		Возврат НачалоДня(ДатаВПериоде);
	КонецЕсли;
	
КонецФункции

// Функция возвращает начало декады по дате.
//
// Параметры:
//	Дата - Дата - Произвольная дата.
//
// Возвращаемое значение:
//	ДатаНачала - Дата - начало декады для переданной даты
//
Функция НачалоДекады(Дата) Экспорт
	
	Если День(Дата) < 10 Тогда
		Возврат НачалоМесяца(Дата);
	ИначеЕсли День(Дата) < 20 Тогда
		Возврат ДобавитьДень(НачалоМесяца(Дата), 10);
	Иначе 
		Возврат ДобавитьДень(НачалоМесяца(Дата), 20);
	КонецЕсли;
	
КонецФункции

// Функция возвращает конец декады по дате.
//
// Параметры:
//	Дата - Дата - Произвольная дата.
//
// Возвращаемое значение:
//	Дата - конец декады для переданной даты
//
Функция КонецДекады(Дата) Экспорт
	
	Если День(Дата) < 10 Тогда
		Возврат ДобавитьДень(Дата, 10) - 1;
	ИначеЕсли День(Дата) < 20 Тогда
		Возврат ДобавитьДень(Дата, 10) - 1;
	Иначе 
		Возврат КонецМесяца(Дата);
	КонецЕсли;
	
КонецФункции // КонецДекады() 

// Функция возвращает начало полугодия по дате.
//
// Параметры:
//	Дата - Дата - Произвольная дата.
//
// Возвращаемое значение:
//	ДатаНачала - Дата - начало полугодия для переданной даты
//
Функция НачалоПолугодия(Дата) Экспорт
	
	Если Месяц(Дата) < 7 Тогда
		Возврат НачалоГода(Дата);
	Иначе
		Возврат ДобавитьМесяц(НачалоГода(Дата), 6);
	КонецЕсли;
	
КонецФункции

// Функция возвращает конец полугодия по дате.
//
// Параметры:
//	Дата - Дата - Произвольная дата.
//
// Возвращаемое значение:
//	ДатаНачала - Дата - начало полугодия для переданной даты
//
Функция КонецПолугодия(Дата) Экспорт
	
	Если Месяц(Дата) < 7 Тогда
		Возврат КонецДня(Дата(Год(Дата), 6, 30));
	Иначе
		Возврат КонецГода(Дата);
	КонецЕсли;
	
КонецФункции

// Функция возвращает дату начала недели с учетом начала месяца
//
// Параметры:
//	Дата - Дата - Произвольная дата.
//
// Возвращаемое значение:
//	ДатаНачала - Дата - начало недели
//
Функция НачалоНеделиПоМесяцу(Дата) Экспорт
	
	Если День(Дата) < 7 Тогда
		Возврат ?(День(НачалоНедели(Дата)) > День(Дата), НачалоМесяца(Дата), НачалоНедели(Дата));
	Иначе
		Возврат НачалоНедели(Дата);
	КонецЕсли;
	
КонецФункции

// Функция возвращает дату окончания периода
//
// Параметры:
//	Дата - Дата - произвольная дата.
//	Периодичность - Перечисления.Периодичность - периодичность планирования по сценарию.
//
// Возвращаемое значение:
//	ДатаКонцаПериода - дата окончания периода
//
Функция ДатаКонцаПериода(Дата, Периодичность) Экспорт
	
	Если НЕ ТипЗнч(Дата) = Тип("Дата") Тогда
		Возврат '00010101';
	КонецЕсли;
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		Возврат КонецНедели(Дата);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Возврат КонецДекады(Дата);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		Возврат КонецМесяца(Дата);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		Возврат КонецКвартала(Дата);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Возврат КонецПолугодия(Дата);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		Возврат КонецГода(Дата);
	Иначе
		Возврат КонецДня(Дата);
	КонецЕсли;
	
КонецФункции

// Функция возвращает представление периода с учетом периодичности
//
// Параметры:
//	ДатаНачала - Дата - произвольная дата.
//	Периодичность - Перечисления.Периодичность - периодичность.
//
// Возвращаемое значение:
//	Предстваление - Строка - предстваление периода
//
Функция ПредставлениеПериодаПоДате(ДатаНачала, Периодичность) Экспорт
	
	Представление = "";
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Представление = НСтр("ru = 'Неделя с %1'");
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Представление, Формат(ДатаНачала, "ДФ=dd.MM.yyyy"));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		Если День(ДатаНачала) < 10 Тогда
			Представление = НСтр("ru = '1 декада. %1'");
		ИначеЕсли День(ДатаНачала) < 20 Тогда
			Представление = НСтр("ru = '2 декада. %1'");
		Иначе 
			Представление = НСтр("ru = '3 декада. %1'");
		КонецЕсли;
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Представление, Формат(ДатаНачала, "ДФ='ММММ гггг'"));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Представление = ПредставлениеПериода(ДатаНачала, КонецМесяца(ДатаНачала), "ФП = Истина");
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Представление = ПредставлениеПериода(ДатаНачала, КонецКвартала(ДатаНачала), "ФП = Истина");
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Представление = ПредставлениеПериода(ДатаНачала, КонецПолугодия(ДатаНачала), "ФП = Истина");
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Представление = ПредставлениеПериода(ДатаНачала, КонецГода(ДатаНачала), "ФП = Истина");
		
	Иначе
		
		Представление = Формат(ДатаНачала, "ДЛФ=D");
		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Функция возвращает число цифрами и период в нужном падеже
//
// Параметры:
// 	 ЧислоПериодов - Число - количество периодов
// 	 Периодичность - ПеречислениеСсылка.Периодичность - периодичность периодов
//
// Возвращаемое значение:
// 	 Представление - Строка
//
Функция ПериодЦифрамиПериодичностьПрописью(ЧислоПериодов, Периодичность) Экспорт
	
	ОписаниеДлительности = "";
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		ОписаниеДлительности = "день, дня, дней";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		ОписаниеДлительности = "неделя, недели, недель";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		ОписаниеДлительности = "декада, декады, декад";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		ОписаниеДлительности = "месяц, месяца, месяцев";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		ОписаниеДлительности = "квартал, квартала, кварталов";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		ОписаниеДлительности = "полугодие, полугодия, полугодий";
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		ОписаниеДлительности = "год, года, лет";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(ЧислоПериодов, ОписаниеДлительности);
	
КонецФункции

#КонецОбласти

#КонецОбласти
