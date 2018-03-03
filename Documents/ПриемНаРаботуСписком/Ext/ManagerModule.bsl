﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ПриемНаРаботуСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплаты,ЧтениеДанныхДляНачисленияЗарплаты", , Ложь) Тогда
		
		// Бронирование позиции
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПодтверждениеБронированияПозиции";
		КомандаПечати.Представление = НСтр("ru = 'Подтверждение брони'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьБронированиеПозиций";
			
		// Приказ о приеме
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_Т1а";
		КомандаПечати.Порядок = 10;
		КомандаПечати.Представление = НСтр("ru = 'Приказ о приеме (Т-1а)'");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеКадровогоСостоянияРасширенная,ЧтениеКадровогоСостоянияРасширенная", , Ложь) Тогда
		
		// Трудовой договор
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ТрудовойДоговор";
		КомандаПечати.Представление = НСтр("ru = 'Трудовые договоры'");
		КомандаПечати.Порядок = 20;
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
		// Трудовой договор микропредприятий
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
		КомандаПечати.Идентификатор = "ПФ_MXL_ТрудовойДоговорМикропредприятий";
		КомандаПечати.Представление = НСтр("ru = 'Трудовой договор (микропредприятий)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеКадровогоСостоянияРасширенная,ЧтениеКадровогоСостоянияРасширенная", , Ложь) Тогда
		
		// Трудовой договор при дистанционной работе.
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ТрудовойДоговорПриДистанционнойРаботе";
		КомандаПечати.Представление = НСтр("ru = 'Трудовые договоры при дистанционной работе'");
		КомандаПечати.Порядок = 30;
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ДобавитьКомандыПечатиДокументаПриемНаРаботу(КомандыПечати);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 
	
	ДанныеДляПроверкиОграничений = Новый Массив;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудники", Объект.Сотрудники.Выгрузить(, "Подразделение,ФизическоеЛицо"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПриемНаРаботуСпискомСотрудники.Подразделение КАК Подразделение,
		|	ПриемНаРаботуСпискомСотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&Сотрудники КАК ПриемНаРаботуСпискомСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Сотрудники.Подразделение КАК Подразделение,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|
		|УПОРЯДОЧИТЬ ПО
		|	Подразделение,
		|	ФизическоеЛицо";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Подразделение") Цикл
		
		ОписаниеСтруктурыДанных = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
		ОписаниеСтруктурыДанных.Организация = Объект.Организация;
		ОписаниеСтруктурыДанных.Подразделение = Выборка.Подразделение;
		
		Пока Выборка.Следующий() Цикл
			Если ОписаниеСтруктурыДанных.МассивФизическихЛиц = Неопределено Тогда
				ОписаниеСтруктурыДанных.МассивФизическихЛиц = Новый Массив;
			КонецЕсли; 
			ОписаниеСтруктурыДанных.МассивФизическихЛиц.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла; 
		
		ДанныеДляПроверкиОграничений.Добавить(ОписаниеСтруктурыДанных);

	КонецЦикла;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	Возврат Документы.ПриемНаРаботу.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок, Истина);
														
КонецФункции	

Процедура ЗаполнитьИдентификаторыСтрокСотрудников() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.ПриемНаРаботуСписком.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.ИдентификаторСтрокиСотрудника = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			ИдентификаторыСотрудников = Новый Соответствие;
			МаксимальныйИдентификаторСтрокиСотрудника = 1;
			Для каждого СтрокаСотрудника Из ДокументОбъект.Сотрудники Цикл
				
				СтрокаСотрудника.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
				ИдентификаторыСотрудников.Вставить(СтрокаСотрудника.Сотрудник, СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
				
				МаксимальныйИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника + 1;
				
			КонецЦикла;
			
			Для каждого СтрокаДокумента Из ДокументОбъект.Начисления Цикл
				СтрокаДокумента.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаДокумента.УдалитьСотрудник);
			КонецЦикла;
			
			Для каждого СтрокаДокумента Из ДокументОбъект.УправленческиеНачисления Цикл
				СтрокаДокумента.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаДокумента.УдалитьСотрудник);
			КонецЦикла;
			
			Для каждого СтрокаДокумента Из ДокументОбъект.Показатели Цикл
				СтрокаДокумента.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаДокумента.УдалитьСотрудник);
			КонецЦикла;
			
			Для каждого СтрокаДокумента Из ДокументОбъект.ЕжегодныеОтпуска Цикл
				СтрокаДокумента.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаДокумента.УдалитьСотрудник);
			КонецЦикла;
			
			Для каждого СтрокаДокумента Из ДокументОбъект.Льготы Цикл
				СтрокаДокумента.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаДокумента.УдалитьСотрудник);
			КонецЦикла;
			
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
