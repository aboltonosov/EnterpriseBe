﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ШтатноеРасписаниеНаПодпись");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Количество штатных единиц и ФОТ, как по позициям, так и сводно по должностям'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СоблюдениеШтатногоРасписания");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сопоставление штатного расписания и фактически занятых позиций 
		|штатного расписания. ""Перерасход"" ставок отображается красным'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализШтатногоРасписания");
	НастройкиВарианта.Описание =
		НСтр("ru = 'План-фактный анализ штатного расписания, как по ставкам, так и по ФОТ'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализШтатногоРасписанияИспользуетсяВилкаСтавок");
	НастройкиВарианта.Описание =
		НСтр("ru = 'План-фактный анализ штатного расписания, как по ставкам, так и по ФОТ'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Расшифровка");
	НастройкиВарианта.Включен = Ложь;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РегламентированныйОтчетСтатистикаФорма1ТГМС");
	НастройкиВарианта.Включен = Ложь;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РегламентированныйОтчетСтатистикаФорма14");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли