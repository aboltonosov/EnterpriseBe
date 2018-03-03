﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Т51ПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетная ведомость за первую половину месяца'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетныйЛистокПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетные листки за первую половину месяца'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетные листки за первую половину месяца, разбитые по источникам финансирования'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Форма0504402ПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетная ведомость 0504402 за первую половину месяца'");
	
КонецПроцедуры

Функция ПечатьТ49(Документ) Экспорт
	
	ОтчетОбъект = Отчеты.АнализНачисленийИУдержанийАвансом.Создать();
	ОтчетОбъект.ИнициализироватьОтчет();
	
	ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти("Т49ПерваяПоловинаМесяца");
	Если ВариантОтчета= Неопределено Тогда
		Возврат Новый ТабличныйДокумент;
	КонецЕсли;
	
	НастройкиОтчета = ВариантОтчета.Настройки;
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "ПериодРегистрации,Организация,Подразделение");
	
	Период = РеквизитыДокумента.ПериодРегистрации;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Период", Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	СтруктураПараметров.Вставить("НачалоПериода",				НачалоМесяца(Период));
	СтруктураПараметров.Вставить("КонецПериода",				КонецМесяца(Период));
	
	Для каждого ПараметрЗаполнения Из СтруктураПараметров Цикл
		
		ПараметрКомпоновкиДанных = Новый ПараметрКомпоновкиДанных(ПараметрЗаполнения.Ключ);
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновкиДанных);
		Если ЗначениеПараметра <> Неопределено Тогда
			ЗначениеПараметра.Значение = ПараметрЗаполнения.Значение;
			ЗначениеПараметра.Использование = Истина;
		Иначе
			НовыйПараметр = НастройкиОтчета.ПараметрыДанных.Элементы.Добавить();
			НовыйПараметр.Параметр = ПараметрКомпоновкиДанных;
			НовыйПараметр.Значение = ПараметрЗаполнения.Значение;
			НовыйПараметр.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеВедомости = Документы[Документ.Метаданные().Имя].ДанныеВедомостиДляПечати(Документ);
	СписокСотрудников = ДанныеВедомости.ВыгрузитьКолонку("Сотрудник");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор, "Сотрудник.ГоловнойСотрудник", СписокСотрудников, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		НастройкиОтчета.Отбор, "Организация", РеквизитыДокумента.Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор, "Подразделение", РеквизитыДокумента.Подразделение, ВидСравненияКомпоновкиДанных.ВИерархии, , Истина);
	КонецЕсли;
	
	ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Документ", Документ);
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ДанныеВедомости", ДанныеВедомости);
	Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
		ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПодразделениеВШапке", РеквизитыДокумента.Подразделение);
	КонецЕсли;
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ОтчетОбъект.СкомпоноватьРезультат(ДокументРезультат);
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти

#КонецЕсли